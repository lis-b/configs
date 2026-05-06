# Conventions

## Untracked files

Use `.untracked/` at the repo root for any local files that shouldn't be committed — plans, notes, test files, etc. Subdirectories are fine (e.g. `.untracked/plans/`, `.untracked/docs/`). Create `.untracked/.gitignore` containing `*` if it doesn't exist yet, so nothing touches the shared `.gitignore`.

## Dev servers

Don't start dev servers yourself. When one is needed, ask me to run it in a separate terminal — backgrounded processes inside Claude Code aren't visible anywhere, which makes it hard to track what's running when I'm working across multiple worktrees in parallel. Reference an already-running process I told you about, but don't spawn new ones.