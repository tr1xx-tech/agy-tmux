# agy-tmux

A handy script to manage your tmux sessions for `agy` (Antigravity CLI). It automatically creates, attaches, or deletes isolated tmux sessions without needing complex tmux commands, running directly from your current working directory.

## Quick Install

Run this single command to install `gem` globally on your system:

```bash
curl -sL https://raw.githubusercontent.com/tr1xx-tech/agy-tmux/main/install.sh | bash
```

## Usage

Simply type `gem` to start or attach to the default `agy` session.

```bash
# Open/create default session and run agy
gem

# Show help and all available commands
gem -h

# Open/create session 'agy-1'
gem 1

# Delete session 'agy-1'
gem -d 1

# List all active sessions
gem -l
```
