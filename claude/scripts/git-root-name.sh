#!/bin/bash
# Always prints the real repo root name, even from a linked worktree.

cwd=$(jq -r '.cwd // empty' 2>/dev/null)
[ -z "$cwd" ] && exit 0
cd "$cwd" 2>/dev/null || exit 0

git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null) || exit 0

# git-common-dir points to the real .git — parent is the repo root
repo_root=$(cd "$git_common_dir/.." 2>/dev/null && pwd)
basename "$repo_root"
