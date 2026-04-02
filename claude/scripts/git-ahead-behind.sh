#!/bin/bash
# Reads cwd from Claude Code's stdin JSON, shows git ahead/behind counts vs upstream.
# Output: "↓N ↑N" (only non-zero counts shown). Empty if no git or no upstream.

cwd=$(jq -r '.cwd // empty' 2>/dev/null)
[ -z "$cwd" ] && exit 0
cd "$cwd" 2>/dev/null || exit 0

counts=$(git rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null) || exit 0

behind=$(echo "$counts" | awk '{print $1}')
ahead=$(echo "$counts" | awk '{print $2}')

parts=""
[ "$behind" -gt 0 ] 2>/dev/null && parts="↓${behind}"
[ "$ahead" -gt 0 ] 2>/dev/null && parts="${parts:+$parts }↑${ahead}"

echo "$parts"
