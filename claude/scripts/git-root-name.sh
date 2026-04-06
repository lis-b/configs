#!/bin/bash
# Prints the repo root name (even from a linked worktree),
# or the folder path (~/… or absolute) when not in a git repo.

cwd=$(jq -r '.cwd // empty' 2>/dev/null)
[ -z "$cwd" ] && exit 0
cd "$cwd" 2>/dev/null || exit 0

git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null)
if [ $? -eq 0 ]; then
  # git-common-dir points to the real .git — parent is the repo root
  repo_root=$(cd "$git_common_dir/.." 2>/dev/null && pwd)
  basename "$repo_root"
else
  # Not a git repo — show the folder path, collapsing $HOME to ~
  abs=$(pwd)
  case "$abs" in
    "$HOME"/*) echo "~${abs#"$HOME"}" ;;
    "$HOME")   echo "~" ;;
    *)         echo "$abs" ;;
  esac
fi
