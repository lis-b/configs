#!/bin/bash
input=$(cat)
PCT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' | cut -d. -f1)
[ -n "$PCT" ] && echo -n "${PCT}%"
