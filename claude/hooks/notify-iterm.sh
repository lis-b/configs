#!/bin/bash
# Claude Code notification hook that focuses the originating iTerm2 tab on click.
# Extracts the session UUID from ITERM_SESSION_ID (format: w0t0p0:UUID) and
# passes it to focus-iterm-tab.sh via terminal-notifier's -execute flag.
# Shows repo name, branch, and worktree path in the notification.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SESSION_UUID="${ITERM_SESSION_ID#*:}"

# Build context subtitle from git info
BRANCH=$(git branch --show-current 2>/dev/null)
GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)
COMMON_DIR=$(git rev-parse --git-common-dir 2>/dev/null)
WORKTREE_DIR=$(git rev-parse --show-toplevel 2>/dev/null)

# Get the real repo name from the common git dir (not the worktree dir)
if [ -n "$COMMON_DIR" ] && [ "$COMMON_DIR" != ".git" ]; then
  # In a worktree: common dir is like /path/to/repo/.git
  REPO=$(basename "$(dirname "$COMMON_DIR")")
else
  # Main working copy: use toplevel
  REPO=$(basename "$WORKTREE_DIR" 2>/dev/null)
fi

CONTEXT=""
if [ -n "$REPO" ]; then
  CONTEXT="$REPO"
  if [ -n "$BRANCH" ]; then
    CONTEXT="$CONTEXT ($BRANCH)"
  fi
  # Show worktree name only when in an actual worktree
  if [ -n "$COMMON_DIR" ] && [ "$COMMON_DIR" != ".git" ] && [ "$GIT_DIR" != "$COMMON_DIR" ]; then
    WORKTREE_NAME=$(basename "$WORKTREE_DIR")
    CONTEXT="$CONTEXT [wt: $WORKTREE_NAME]"
  fi
fi

if [ -n "$REPO" ]; then
  TITLE="⚠️ $REPO"
else
  TITLE="⚠️ Claude Code"
fi

if [ -n "$WORKTREE_NAME" ]; then
  SUBTITLE="${BRANCH:-no branch} (wt: $WORKTREE_NAME)"
else
  SUBTITLE="${BRANCH:-no branch}"
fi

MESSAGE="Claude needs your attention"

if [ -n "$SESSION_UUID" ]; then
  terminal-notifier \
    -title "$TITLE" \
    -subtitle "$SUBTITLE" \
    -message "$MESSAGE" \
    -sound Glass \
    -execute "$SCRIPT_DIR/focus-iterm-tab.sh $SESSION_UUID"
else
  terminal-notifier \
    -title "$TITLE" \
    -subtitle "$SUBTITLE" \
    -message "$MESSAGE" \
    -sound Glass \
    -activate com.googlecode.iterm2
fi
