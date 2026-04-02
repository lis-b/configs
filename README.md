# configs

Personal dotfiles and config files. Symlinked from their real locations so edits stay in sync.

## What's included

| Directory | What | Symlinked from |
|-----------|------|----------------|
| `claude/settings.json` | Claude Code settings (hooks, statusline, plugins) | `~/.claude/settings.json` |
| `claude/hooks/` | Notification & tab-focus scripts for Ghostty/iTerm | `~/.claude/hooks/` |
| `claude/scripts/` | Statusline scripts (git root, worktree, status indicators) | `~/.claude/*.sh` |
| `ghostty/` | Ghostty terminal config | `~/Library/Application Support/com.mitchellh.ghostty/` |
| `ccstatusline/` | ccstatusline widget layout | `~/.config/ccstatusline/` |
| `shell/` | zshrc and p10k config | `~/` |

## Setup on a new machine

```bash
git clone <repo-url> ~/repos/configs
cd ~/repos/configs
./install.sh
```

The install script backs up any existing files to `.bak` before symlinking.
