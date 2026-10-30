#!/usr/bin/env bash
#
# sync.sh — pull live configs from this machine into the dotfiles repo.
#
# For every app the repo tracks, copy the config from its real location on
# this machine into the repo, then commit.
#
# Safety rules:
#   - Missing sources are skipped; the repo copy is left untouched.
#   - Dirs that only contain junk (.DS_Store, .netrwhist, .claude) are
#     treated as "not installed here" and skipped. This protects configs
#     for apps that aren't used on this machine.
#   - Dir sources are mirrored (rsync --delete), so files deleted on the
#     live machine are deleted from the repo too.
#
# Usage:
#   ./sync.sh            sync + commit
#   ./sync.sh -n         sync only, don't commit
#   ./sync.sh -p         sync + commit + push
#   ./sync.sh -np        sync only, no commit, no push

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

COMMIT=1
PUSH=0
while [ $# -gt 0 ]; do
  case "$1" in
    -n|--no-commit) COMMIT=0 ;;
    -p|--push) PUSH=1 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//' ; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

if [ -f "$HOME/.agents/mcp.json" ]; then
  python3 - <<'PY'
import json, os
from pathlib import Path
root = Path.home() / '.agents'
servers = {}
for name, source in json.loads((root / 'mcp.json').read_text()).get('mcpServers', {}).items():
    server = {'type': 'remote' if 'url' in source else 'local'}
    if 'url' in source:
        server['url'] = source['url']
        if 'headers' in source:
            server['headers'] = source['headers']
            server['oauth'] = False
    else:
        server['command'] = [source['command'], *source.get('args', [])]
        if 'env' in source:
            server['environment'] = source['env']
        if 'cwd' in source:
            server['cwd'] = source['cwd']
    server['disabled'] = source.get('disabled', not source.get('enabled', True))
    servers[name] = server
target = root / 'opencode.json'
config = json.loads(target.read_text()) if target.exists() else {}
config.setdefault('mcp', {})['servers'] = servers
fd = os.open(target, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
with os.fdopen(fd, 'w') as output:
    json.dump(config, output, indent=2)
    output.write('\n')
target.chmod(0o600)
PY
fi

mkdir -p "$HOME/.config/opencode" opencode
for name in AGENTS.md skills opencode.json; do
  live="$HOME/.config/opencode/$name"
  if [ ! -e "$HOME/.agents/$name" ]; then
    continue
  fi
  if [ -e "$live" ] && [ ! -L "$live" ]; then
    echo "Refusing to replace existing config: $live" >&2
    exit 1
  fi
  ln -sfn "../../.agents/$name" "$live"
  ln -sfn "../agents/$name" "opencode/$name"
done

# src <TAB> dest (relative to repo root). Files are copied, dirs are mirrored.
SYNC_PAIRS=$(
  cat <<EOF
$HOME/.bashrc	.bashrc
$HOME/.tmux.conf	.tmux.conf
$HOME/.config/alacritty	alacritty
$HOME/.config/ghostty	ghostty
$HOME/.config/herdr/config.toml	herdr/config.toml
$HOME/.config/herdr/dayowl-theme.toml	herdr/dayowl-theme.toml
$HOME/.config/herdr/nightowl-theme.toml	herdr/nightowl-theme.toml
$HOME/.config/herdr/polar-aurora-theme.toml	herdr/polar-aurora-theme.toml
$HOME/.config/herdr/charcoal-atelier-theme.toml	herdr/charcoal-atelier-theme.toml
$HOME/.vscode/extensions/mmc.charcoal-atelier-1.0.0	vscode/charcoal-atelier
$HOME/.cursor/extensions/mmc.charcoal-atelier-1.0.0	cursor/charcoal-atelier
$HOME/.config/nvim	nvim
$HOME/.vimrc	vim/vimrc
$HOME/.vim/colors/polar-aurora.vim	vim/colors/polar-aurora.vim
$HOME/.vscode/extensions/mmc.polar-aurora-1.0.0/themes/polar-aurora-color-theme.json	vscode/polar-aurora/themes/polar-aurora-color-theme.json
$HOME/.cursor/extensions/mmc.polar-aurora-1.0.0/themes/polar-aurora-color-theme.json	cursor/polar-aurora/themes/polar-aurora-color-theme.json
$HOME/.config/opencode/cli.json	opencode/cli.json
$HOME/.config/opencode/themes	opencode/themes
$HOME/.agents	agents
$HOME/.cursor/rules	cursor/rules
$HOME/.claude/themes	claude/themes
$HOME/.pi/agent/themes	pi/themes
$HOME/.codex/themes	codex/themes
EOF
)

# Junk that is never mirrored into the repo.
RSYNC_EXCLUDES=(--exclude '.DS_Store' --exclude '.netrwhist' --exclude '.claude' --exclude '/undo' --exclude '*.bak-*' --exclude '/mcp.json' --exclude '/opencode.json' --exclude '__pycache__')

# True if a dir has no entries other than junk (i.e. the app isn't really
# set up here), so mirroring it would only wipe the repo copy.
dir_emptyish() {
  shopt -s nullglob dotglob
  local dir="$1" entry real=0
  for entry in "$dir"/*; do
    case "${entry##*/}" in
      .DS_Store|.netrwhist|.claude) ;;
      *) real=1; break ;;
    esac
  done
  [ "$real" -eq 0 ]
}

synced=0
skipped=0
while IFS=$'\t' read -r src dest; do
  [ -n "$src" ] || continue

  if [ -d "$src" ]; then
    if dir_emptyish "$src"; then
      echo "skip:  $src (no usable files)"
      skipped=$((skipped + 1))
      continue
    fi
    mkdir -p "$dest"
    rsync -a --delete "${RSYNC_EXCLUDES[@]}" "$src"/ "$dest"/
  elif [ -f "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    cp -p "$src" "$dest"
  else
    echo "skip:  $src (missing)"
    skipped=$((skipped + 1))
    continue
  fi
  echo "sync:  $src -> $dest"
  synced=$((synced + 1))
done <<< "$SYNC_PAIRS"

if [ -f "$HOME/.zshrc" ]; then
  mkdir -p zsh
  sed -n -e '/^autoload -Uz vcs_info$/p' -e '/^precmd() { vcs_info; PROMPT=/p' -e "/^zstyle ':vcs_info:git:\*' formats /p" -e '/^unsetopt PROMPT_SUBST$/p' "$HOME/.zshrc" > zsh/prompt.zsh
fi

if [ -f "$HOME/.codex/config.toml" ]; then
  mkdir -p codex
  python3 - <<'PY'
import json, tomllib
from pathlib import Path
config = tomllib.loads((Path.home() / '.codex/config.toml').read_text())
tui = config.get('tui', {})
keys = ('theme', 'animations', 'terminal_title')
appearance = '[tui]\n' + ''.join(f'{key} = {json.dumps(tui[key])}\n' for key in keys if key in tui)
dark = config.get('desktop', {}).get('appearanceDarkChromeTheme', {})
if dark:
    appearance += '\n[desktop.appearanceDarkChromeTheme]\n' + ''.join(f'{key} = {json.dumps(dark[key])}\n' for key in ('accent', 'accentSource', 'contrast', 'ink', 'opaqueWindows', 'surface') if key in dark)
Path('codex/appearance.toml').write_text(appearance)
PY
fi

python3 - <<'PY'
import json, re
from pathlib import Path
for app, dest in (('Code', 'vscode'), ('Cursor', 'cursor')):
    source = Path.home() / 'Library/Application Support' / app / 'User/settings.json'
    if source.exists():
        settings = {}
        for key in ('window.autoDetectColorScheme', 'workbench.colorTheme', 'workbench.preferredLightColorTheme', 'workbench.preferredDarkColorTheme'):
            match = re.search(r'"' + re.escape(key) + r'"\s*:\s*("(?:[^"\\]|\\.)*"|true|false)', source.read_text())
            if match:
                settings[key] = json.loads(match[1])
        Path(dest).mkdir(exist_ok=True)
        Path(dest, 'appearance.json').write_text(json.dumps(settings, indent=2) + '\n')
PY

echo
echo "synced $synced source(s), skipped $skipped."

if [ "$(git status --porcelain | wc -l | tr -d ' ')" -eq 0 ]; then
  echo "No changes to commit."
  exit 0
fi

git status --short

if [ "$COMMIT" -eq 1 ]; then
  git add -A
  git diff --cached --stat
  git commit -q -m "Sync configs from live sources"
  echo "Committed."
  if [ "$PUSH" -eq 1 ]; then
    git push
  fi
fi
