# Conventions

## Untracked files

Use `.untracked/` at the repo root for any local files that shouldn't be committed — plans, notes, test files, etc. Subdirectories are fine (e.g. `.untracked/plans/`, `.untracked/docs/`). Create `.untracked/.gitignore` containing `*` if it doesn't exist yet, so nothing touches the shared `.gitignore`.