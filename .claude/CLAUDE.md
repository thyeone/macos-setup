# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A macOS dotfiles and setup automation repo. Running `./setup.sh` (or `./setup.sh --all`) symlinks config files into `$HOME` and installs tooling. There is no build step, no tests, and no package manager for the repo itself.

## Running Setup

```bash
./setup.sh          # Interactive — prompts for each component
./setup.sh --all    # Non-interactive — installs everything
```

Individual components can be run directly:

```bash
zsh brew/setup.sh
zsh nvm/setup.sh
zsh git/setup.sh
zsh zsh/setup.sh
zsh cursor/setup.sh
```

## Architecture

Each component lives in its own directory with a `setup.sh` that is sourced by the top-level `setup.sh`:

| Directory | What it does |
|-----------|-------------|
| `brew/` | Installs Homebrew, then runs `brew bundle` against `Brewfile` |
| `nvm/` | Installs Node.js LTS via nvm (nvm itself comes from Homebrew) |
| `git/` | Symlinks `.gitconfig` and `.gitignore` into `$HOME` |
| `zsh/` | Symlinks `.zshrc` into `$HOME` |
| `cursor/` | Symlinks `settings.json` into `~/Library/Application Support/Cursor/User/` and batch-installs extensions from `vscode-extensions.txt` |

All setup scripts use the same symlink pattern: back up existing file → create symlink from repo path to home path.

## Key Config Files

- `brew/Brewfile` — the canonical list of CLI tools and GUI apps to install
- `zsh/.zshrc` — shell config; includes nvm init, Android SDK paths, and the `cl` alias for Claude (`claude --dangerously-skip-permissions`)
- `git/.gitconfig` — global git config (name, email, `push.autoSetupRemote`, `rebase.autoStash`)
- `git/.gitignore` — global gitignore (macOS, Node.js, build artifacts, env files)
- `cursor/vscode-extensions.txt` — one extension ID per line, installed via `cursor --install-extension`

## Updating Extensions

To export the current extension list from Cursor:

```bash
cursor --list-extensions > cursor/vscode-extensions.txt
```
