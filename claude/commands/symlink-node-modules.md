---
description: Symlink this worktree's node_modules to the base repo's to save disk space
---

Symlink this worktree's `node_modules` directories to the base repo's, so multiple worktrees share one installed `node_modules` (often 2-3GB each) instead of duplicating them.

## What to do

1. Find the base repo and current worktree:
   - Base repo path = first entry from `git worktree list --porcelain | awk '/^worktree/ {print $2}'`
   - Current worktree path = `git rev-parse --show-toplevel`

2. **Bail** if the current dir IS the base repo — `node_modules` there is the real thing, not something to overwrite. Tell the user to `cd` into a worktree.

3. **Bail** if the base repo has no `node_modules/` — tell the user to run `yarn install` (or `npm install` / `pnpm install`) in the base repo first.

4. For each `node_modules` path that exists in the base repo (root, plus any `packages/*/node_modules`), check the corresponding path in this worktree:
   - **Correct symlink already** → ✓ skip, mention it
   - **Missing** → `ln -s <base>/node_modules <worktree>/node_modules`, ✓ done
   - **Real directory** → run `du -sh` to report size, **ask the user to confirm** before `rm -rf` and symlinking
   - **Symlink pointing somewhere else** → ask before replacing

5. Print a summary: what was linked, what was skipped, approx disk space freed.

## Flag this at the end

`yarn install` (or equivalent) in any worktree now mutates `node_modules` for every worktree sharing the symlink. Fine when branches have identical `package.json` deps; breaks the others when deps diverge. Undo for a worktree: `rm <worktree>/node_modules` (safe — only removes the symlink) and `yarn install` to repopulate.
