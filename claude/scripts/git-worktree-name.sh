#!/bin/bash
# Reads cwd from Claude Code's stdin JSON, prints the worktree name if in a linked worktree.
# Empty output if cwd is the main worktree or not in a git repo.

cwd=$(jq -r '.cwd // empty' 2>/dev/null)
[ -z "$cwd" ] && exit 0
cd "$cwd" 2>/dev/null || exit 0

# Check if we're in a linked worktree (not the main one)
git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null) || exit 0
git_dir=$(git rev-parse --git-dir 2>/dev/null) || exit 0

# Resolve to absolute paths for comparison
git_common_dir=$(cd "$cwd" && cd "$git_common_dir" 2>/dev/null && pwd)
git_dir=$(cd "$cwd" && cd "$git_dir" 2>/dev/null && pwd)

# If git-dir equals git-common-dir, we're in the main worktree — print nothing
[ "$git_dir" = "$git_common_dir" ] && exit 0

# We're in a linked worktree — print its name
toplevel=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
echo "[$(basename "$toplevel")]"
