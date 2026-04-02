# configs

Personal dotfiles and config files. Symlinked from their real locations so edits stay in sync.

## What's included

| Directory | What | Symlinked from |
|-----------|------|----------------|
| `claude/settings.json` | Claude Code settings (hooks, statusline, plugins) | `~/.claude/settings.json` |
| `claude/hooks/` | Notification & tab-focus scripts for Ghostty | `~/.claude/hooks/` |
| `claude/scripts/` | Statusline scripts (git root, worktree, status indicators, context bar) | `~/.claude/*.sh` |
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

## Notes

- `claude/scripts/context-bar.sh` displays a color-coded context usage bar in the statusline. The percentage is doubled so the bar treats 50% of the actual context window (500k) as full — adjust the multiplier in the script if needed.
