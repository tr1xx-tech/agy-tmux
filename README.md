# 💎 Antigravity for SSH (gem)

A handy script to manage your `tmux` sessions for `agy` (Antigravity CLI). It automatically creates, attaches, or deletes isolated tmux sessions without needing complex commands, running directly from your current working directory.

## 🤔 Why is this useful?

If you run Antigravity CLI on a remote server via SSH, you face a few challenges that this script elegantly solves:
- **Connection Drops:** If your SSH connection disconnects, your `agy` session and its ongoing tasks won't die. You can simply reconnect and type `gem` to resume exactly where you left off.
- **Multitasking:** Need to run multiple agents in parallel for different projects? Use `gem 1`, `gem 2`, etc., to spawn and jump between isolated background sessions in seconds.
- **Convenience:** Replaces tedious `tmux new-session`, `tmux attach`, or `tmux kill-session` commands with a fast, single-word shortcut `gem`.

## 🚀 Quick Install

Run this single command to install `gem` globally on your system:

```bash
curl -sL https://raw.githubusercontent.com/tr1xx-tech/agy-tmux/main/install.sh | bash
```

## 📖 Usage

Simply type `gem` to start or attach to the default `agy` session. For more advanced features, check out the options below:

```text
Usage: gem [options] [suffix]

Manage tmux sessions for agy (Antigravity CLI).

Commands & Options:
  -h, --help, h, help      Show this help message
  -s, --session SUFFIX     Open or create session agy-<suffix>
  -d, --delete SUFFIX      Delete session agy-<suffix>
  -l, --list, l, list      List all active tmux sessions
  -c, --continue, c        Start agy with the last dialog (agy -c) if session is created
  [suffix]                 Open or create session agy-<suffix> (positional)
  d [suffix]               Delete session agy-<suffix> (positional)

Examples:
  gem                      Open/create session 'agy' and run 'agy'
  gem 1                    Open/create session 'agy-1' and run 'agy'
  gem c                    Open/create session 'agy' and run 'agy -c'
  gem c 1                  Open/create session 'agy-1' and run 'agy -c'
  gem -d 1 / gem d 1       Delete session 'agy-1'
  gem -l / gem l           List all active tmux sessions
```
