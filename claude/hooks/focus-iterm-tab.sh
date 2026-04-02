#!/bin/bash
# Activates iTerm2 and selects the tab containing the given session UUID.
# Called by terminal-notifier when the notification is clicked.
# Usage: focus-iterm-tab.sh <session-uuid>

osascript <<EOF
tell application "iTerm2"
  activate
  repeat with w in windows
    repeat with t in tabs of w
      repeat with s in sessions of t
        if id of s is "$1" then
          select t
        end if
      end repeat
    end repeat
  end repeat
end tell
EOF
