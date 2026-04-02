#!/bin/bash
# p10k-style git status indicators for ccstatusline
# Shows: ⇣behind ⇡ahead +staged !unstaged ?untracked

cwd=$(jq -r '.cwd // empty' 2>/dev/null)
[ -z "$cwd" ] && exit 0
cd "$cwd" 2>/dev/null || exit 0

git rev-parse --git-dir &>/dev/null || exit 0

parts=()

# Commits behind/ahead of remote
read -r behind ahead <<< "$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null | tr '\t' ' ')"
[ "$behind" -gt 0 ] 2>/dev/null && parts+=("⇣${behind}")
[ "$ahead" -gt 0 ] 2>/dev/null && parts+=("⇡${ahead}")

# Staged, unstaged, untracked counts from porcelain status
staged=0 unstaged=0 untracked=0
while IFS= read -r line; do
  x="${line:0:1}"
  y="${line:1:1}"
  if [ "$x" = "?" ]; then
    ((untracked++))
  else
    [ "$x" != " " ] && [ "$x" != "." ] && ((staged++))
    [ "$y" != " " ] && [ "$y" != "." ] && ((unstaged++))
  fi
done < <(git status --porcelain 2>/dev/null)

[ "$staged" -gt 0 ] && parts+=("+${staged}")
[ "$unstaged" -gt 0 ] && parts+=("!${unstaged}")
[ "$untracked" -gt 0 ] && parts+=("?${untracked}")

# Join with spaces
echo "${parts[*]}"
