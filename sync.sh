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
#     for apps that aren't used on this machine (bash, vim, mpv, ...).
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
$HOME/.vimrc	.vimrc
$HOME/.vim	.vim
$HOME/.config/alacritty	alacritty
$HOME/.config/ghostty	ghostty
$HOME/.config/herdr/config.toml	herdr/config.toml
$HOME/.config/herdr/dayowl-theme.toml	herdr/dayowl-theme.toml
$HOME/.config/herdr/nightowl-theme.toml	herdr/nightowl-theme.toml
$HOME/.config/mpv	mpv
$HOME/.config/nvim	nvim
$HOME/.claude/themes	claude/themes
$HOME/.pi/agent/themes	pi/themes
EOF
)

# Junk that is never mirrored into the repo.
RSYNC_EXCLUDES=(--exclude '.DS_Store' --exclude '.netrwhist' --exclude '.claude' --exclude '*.bak-*')

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
