# Conventions

## Untracked files

Use `.untracked/` at the repo root for any local files that shouldn't be committed — plans, notes, test files, etc. Subdirectories are fine (e.g. `.untracked/plans/`, `.untracked/docs/`). Create `.untracked/.gitignore` containing `*` if it doesn't exist yet, so nothing touches the shared `.gitignore`.

## Dev servers

Do not start dev servers unless explicitly asked. When starting them, always use `run_in_background` so they are properly tracked and cleaned up when the session ends.