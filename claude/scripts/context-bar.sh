#!/bin/bash
input=$(cat)

PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
PCT=$((PCT * 2))
if [ "$PCT" -gt 100 ]; then PCT=100; fi

# Color thresholds
if [ "$PCT" -ge 90 ]; then
  COLOR='\033[31m'       # Red
elif [ "$PCT" -ge 70 ]; then
  COLOR='\033[94m'       # Bright blue (orange in theme)
elif [ "$PCT" -ge 50 ]; then
  COLOR='\033[33m'       # Yellow
else
  COLOR='\033[32m'       # Green
fi

# Build bar (15 segments)
FILLED=$((PCT * 15 / 100))
BAR=""
for ((i = 0; i < FILLED; i++)); do BAR+="▓"; done
for ((i = FILLED; i < 15; i++)); do BAR+="░"; done

RESET='\033[0m'
echo -ne "${COLOR}${BAR} ${PCT}%${RESET}"
