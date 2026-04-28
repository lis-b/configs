#!/bin/bash
# Bootstrap configs on a new machine.
# Run from the repo root: ./install.sh

set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$REPO_DIR/$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "  backup: $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -sf "$src" "$dest"
  echo "  linked: $dest -> $src"
}

echo "Installing configs..."

# Claude Code
link claude/settings.json ~/.claude/settings.json
link claude/hooks/focus-ghostty-tab.sh ~/.claude/hooks/focus-ghostty-tab.sh
link claude/hooks/notify-ghostty.sh ~/.claude/hooks/notify-ghostty.sh
link claude/hooks/set-tab-title.sh ~/.claude/hooks/set-tab-title.sh
link claude/scripts/git-ahead-behind.sh ~/.claude/git-ahead-behind.sh
link claude/scripts/git-root-name.sh ~/.claude/git-root-name.sh
link claude/scripts/git-status-indicators.sh ~/.claude/git-status-indicators.sh
link claude/scripts/git-worktree-name.sh ~/.claude/git-worktree-name.sh

# Ghostty
link ghostty/config.ghostty ~/Library/Application\ Support/com.mitchellh.ghostty/config.ghostty

# ccstatusline
link ccstatusline/settings.json ~/.config/ccstatusline/settings.json

# Shell
link shell/.p10k.zsh ~/.p10k.zsh
link shell/.zshrc ~/.zshrc

echo "Done!"
