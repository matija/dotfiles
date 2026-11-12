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

# src <TAB> dest (relative to repo root). Files are copied, dirs are mirrored.
SYNC_PAIRS=$(
  cat <<EOF
$HOME/.bashrc	.bashrc
$HOME/.tmux.conf	.tmux.conf
$HOME/.vscode/extensions/mmc.charcoal-atelier-1.0.0	vscode/charcoal-atelier
$HOME/.cursor/extensions/mmc.charcoal-atelier-1.0.0	cursor/charcoal-atelier
$HOME/.config/nvim	nvim
$HOME/.vimrc	vim/vimrc
$HOME/.vim/colors/polar-aurora.vim	vim/colors/polar-aurora.vim
$HOME/.vim/colors/charcoal-atelier.vim	vim/colors/charcoal-atelier.vim
$HOME/.vscode/extensions/mmc.polar-aurora-1.0.0/themes/polar-aurora-color-theme.json	vscode/polar-aurora/themes/polar-aurora-color-theme.json
$HOME/.cursor/extensions/mmc.polar-aurora-1.0.0/themes/polar-aurora-color-theme.json	cursor/polar-aurora/themes/polar-aurora-color-theme.json
$HOME/.agents	agents
$HOME/.cursor/rules	cursor/rules
$HOME/.claude/themes	claude/themes
$HOME/.pi/agent/themes	pi/themes
$HOME/.codex/themes	codex/themes
EOF
)

# Junk that is never mirrored into the repo.
RSYNC_EXCLUDES=(--exclude '.DS_Store' --exclude '.netrwhist' --exclude '.claude' --exclude '/undo' --exclude '*.bak-*' --exclude '/mcp.json' --exclude '/opencode.json' --exclude '__pycache__' --exclude '/skills/ego-browser')

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

  if [ -e "$dest" ] && [ "$src" -ef "$dest" ]; then
    echo "skip:  $src (linked to repo)"
    skipped=$((skipped + 1))
    continue
  fi

  if [ -d "$src" ]; then
    if dir_emptyish "$src"; then
      echo "skip:  $src (no usable files)"
      skipped=$((skipped + 1))
      continue
    fi
    mkdir -p "$dest"
    rsync -aL --delete "${RSYNC_EXCLUDES[@]}" "$src"/ "$dest"/
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
desktop = config.get('desktop', {})
if 'appearanceTheme' in desktop:
    appearance += '\n[desktop]\nappearanceTheme = ' + json.dumps(desktop['appearanceTheme']) + '\n'
dark = desktop.get('appearanceDarkChromeTheme', {})
if dark:
    appearance += '\n[desktop.appearanceDarkChromeTheme]\n' + ''.join(f'{key} = {json.dumps(dark[key])}\n' for key in ('accent', 'accentSource', 'contrast', 'ink', 'opaqueWindows', 'surface') if key in dark)
    semantic = dark.get('semanticColors', {})
    if semantic:
        appearance += '\n[desktop.appearanceDarkChromeTheme.semanticColors]\n' + ''.join(f'{key} = {json.dumps(value)}\n' for key, value in semantic.items())
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
