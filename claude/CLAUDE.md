# Conventions

## Untracked files

Use `.untracked/` at the repo root for any local files that shouldn't be committed — plans, notes, test files, etc. Subdirectories are fine (e.g. `.untracked/plans/`, `.untracked/docs/`). Create `.untracked/.gitignore` containing `*` if it doesn't exist yet, so nothing touches the shared `.gitignore`.

## Worktree naming

Use mythology-inspired names for git worktrees — pick randomly from any mythology (Greek, Norse, Egyptian, Hindu, Celtic, Japanese, etc.). Place them at `<repo-root>/.worktrees/<name>` (e.g. `.worktrees/athena`). Use a self-ignoring `.worktrees/.gitignore` containing `*`. The branch name carries the descriptive info; the directory name can be fun.
