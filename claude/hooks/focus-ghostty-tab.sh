#!/bin/bash
# Activates Ghostty and focuses the tab whose terminal's working directory
# contains the given path. Called by terminal-notifier when notification is clicked.
# Usage: focus-ghostty-tab.sh <working-directory>

osascript <<EOF
tell application "Ghostty"
  set matches to every terminal whose working directory contains "$1"
  if (count of matches) > 0 then
    focus (item 1 of matches)
  else
    activate
  end if
end tell
EOF
