#!/bin/bash
# Sets the Ghostty tab title to "<marker> <repo>[<worktree>]" (or
# "<marker> <folder>" outside a git repo). Marker is ✳ when idle, ⠂
# while Claude is working — a static binary indicator.
#
# Wire as multiple hooks:
#   UserPromptSubmit → ./set-tab-title.sh working
#   Stop             → ./set-tab-title.sh idle
#   SessionStart     → ./set-tab-title.sh idle
#   SessionEnd       → ./set-tab-title.sh clear
#
# SessionEnd is safe because the cached terminal id (set during the
# first idle/working hook) lets us target the exact tab the session was
# bound to — no risk of clearing the focused-but-wrong tab.
#
# Reuses git-root-name.sh / git-worktree-name.sh so the title stays in
# sync with the statusline.
#
# WHY osascript + set_tab_title (not OSC escape sequences):
# Ghostty has two titles per tab — the surface title (set via OSC 0/2,
# what Claude continuously writes) and the persistent tab title (set via
# the set_tab_title action, what manual right-click rename uses). The
# tab title locks against OSC overrides, so this approach survives
# Claude's title management without a fight.
#
# WHY the marker dance (not "focused terminal of front window"):
# Hooks fire from background sessions too — UserPromptSubmit/Stop in a
# different tab can target the focused tab and rename the wrong one.
# To target precisely:
#   1. Walk the process tree to find OUR controlling tty.
#   2. Write a unique marker as the SURFACE title via OSC 2 to that tty.
#   3. Ask Ghostty for the terminal whose surface name matches the
#      marker — that's us.
#   4. Cache the terminal id keyed by session_id so subsequent hooks
#      skip the marker dance.
# The TTY-discovery trick is borrowed from claude-code-tab-title (MIT,
# © 2026 Francesco Villano):
# https://github.com/franzvill/claude-code-tab-title
#
# FUTURE: animated swing. To mimic Claude's full ⠂↔⠐ swinging animation
# during working state, spawn a detached osascript that loops between
# two perform actions (using the cached terminal id). Claude's own
# animation cycles faster than 300ms — eyeball it (~100–150ms) or
# capture timing via `script -t 0` for an exact match. Track the loop's
# PID per session, kill on Stop. Heavier — only worth it if the binary
# swap bothers you.

mode="${1:-idle}"
input=$(cat)

session_id=$(echo "$input" | jq -r '.session_id // empty' 2>/dev/null)
session_id_safe=$(echo "${session_id:-default}" | tr -c '[:alnum:]_-' '_')
id_file="/tmp/claude-tab-id-${session_id_safe}"

# Helper: set tab title on a known terminal id. Returns 0 on success.
set_by_id() {
  local result
  result=$(osascript -e 'on run argv
    tell application "Ghostty"
      set matches to every terminal whose id is item 1 of argv
      if (count of matches) > 0 then
        perform action ("set_tab_title:" & item 2 of argv) on (item 1 of matches)
        return "ok"
      end if
    end tell
    return "miss"
  end run' -- "$1" "$2" 2>/dev/null)
  [ "$result" = "ok" ]
}

# SessionEnd clears via cached id — never targets the wrong tab.
if [ "$mode" = "clear" ]; then
  if [ -f "$id_file" ]; then
    cached=$(cat "$id_file" 2>/dev/null)
    [ -n "$cached" ] && set_by_id "$cached" ""
    rm -f "$id_file"
  fi
  exit 0
fi

root=$(echo "$input" | ~/.claude/git-root-name.sh)
wt=$(echo "$input" | ~/.claude/git-worktree-name.sh)
[ -z "$root" ] && exit 0

if [ "$mode" = "working" ]; then
  marker_char="⠂"
else
  marker_char="✳"
fi
title="${marker_char} ${root}${wt}"

# Walk the process tree to find a writable tty for our controlling
# terminal. Hooks have no /dev/tty; the parent claude pty does.
find_tty() {
  local pid=$PPID out tty ppid path
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    [ "$pid" -le 1 ] && return 1
    out=$(ps -o tty=,ppid= -p "$pid" 2>/dev/null) || return 1
    tty=$(echo "$out" | awk '{print $1}')
    ppid=$(echo "$out" | awk '{print $2}')
    if [ -n "$tty" ] && [ "$tty" != "??" ] && [ "$tty" != "?" ]; then
      path="/dev/$tty"
      [ -w "$path" ] && { echo "$path"; return 0; }
    fi
    [ -z "$ppid" ] && return 1
    pid=$ppid
  done
  return 1
}

# Fast path: use the cached terminal id from a previous identification.
if [ -f "$id_file" ]; then
  cached=$(cat "$id_file" 2>/dev/null)
  if [ -n "$cached" ] && set_by_id "$cached" "$title"; then
    exit 0
  fi
  rm -f "$id_file"
fi

# Slow path: identify the terminal via a unique surface-title marker.
# Write fresh marker → query — retry up to 3 times in case Claude
# overwrites the marker before our query lands.
tty_path=$(find_tty) || exit 0
marker="__claudetab_${$}_${RANDOM}__"
new_id=""
for _ in 1 2 3; do
  printf '\033]2;%s\007' "$marker" > "$tty_path" 2>/dev/null
  new_id=$(osascript -e 'on run argv
    tell application "Ghostty"
      set matches to every terminal whose name is item 1 of argv
      if (count of matches) > 0 then
        set t to item 1 of matches
        perform action ("set_tab_title:" & item 2 of argv) on t
        return id of t
      end if
    end tell
    return ""
  end run' -- "$marker" "$title" 2>/dev/null)
  [ -n "$new_id" ] && break
done

[ -n "$new_id" ] && echo "$new_id" > "$id_file"
exit 0
