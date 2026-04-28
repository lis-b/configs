#!/bin/bash
# Claude Code notification hook that focuses the originating Ghostty tab on click.
# Uses the current working directory to find the right terminal in Ghostty's
# AppleScript API. Shows repo name, branch, and worktree path in the notification.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKING_DIR="$(pwd)"

# Build context subtitle from git info
BRANCH=$(git branch --show-current 2>/dev/null)
GIT_DIR=$(cd "$(git rev-parse --git-dir 2>/dev/null)" 2>/dev/null && pwd)
COMMON_DIR=$(cd "$(git rev-parse --git-common-dir 2>/dev/null)" 2>/dev/null && pwd)

# Repo name always comes from the common git dir's parent
if [ -n "$COMMON_DIR" ]; then
  REPO=$(basename "$(dirname "$COMMON_DIR")")
  TITLE="⚠️ $REPO"

  # Worktree detection: git-dir differs from git-common-dir in linked worktrees
  if [ "$GIT_DIR" != "$COMMON_DIR" ]; then
    WORKTREE_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    TITLE="${TITLE}[${WORKTREE_NAME}]"
  fi

  SUBTITLE="${BRANCH:-no branch}"
else
  # Not a git repo — show folder name as title, full path as subtitle
  TITLE="⚠️ $(basename "$WORKING_DIR")"
  case "$WORKING_DIR" in
    "$HOME"/*) SUBTITLE="~${WORKING_DIR#"$HOME"}" ;;
    "$HOME")   SUBTITLE="~" ;;
    *)         SUBTITLE="$WORKING_DIR" ;;
  esac
fi

MESSAGE="Claude needs your attention"

terminal-notifier \
  -title "$TITLE" \
  -subtitle "$SUBTITLE" \
  -message "$MESSAGE" \
  -sound Glass \
  -execute "$SCRIPT_DIR/focus-ghostty-tab.sh '$WORKING_DIR'"
