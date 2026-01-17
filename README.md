# macOS Setup

A personal collection of dotfiles and setup scripts for macOS development environment.

## Overview

This repository contains configuration files and automated setup scripts to quickly configure a new macOS machine with essential development tools and settings.

## Features

- 🍺 **Homebrew**: Package manager installation and package management
- 📦 **Node.js**: Automatic LTS version installation via nvm
- 🔧 **Git**: Global Git configuration and ignore patterns
- 🐚 **Zsh**: Shell configuration and environment setup
- ✏️ **Cursor**: Editor settings and extension management

## Quick Start

```bash
git clone https://github.com/thyeone/macos-setup.git
cd macos-setup

./setup.sh
```

### Installation Modes

**Interactive Mode (Default)**
- The script will prompt you for each configuration step
- Choose which components to install (y/n)
- Allows selective installation of only the components you need

**Automatic Mode**
- Install all components without prompts
- Use the `--all` flag:

```bash
./setup.sh --all
```

### Available Components

The setup script includes the following components:

1. **Homebrew & Packages** - Installs Homebrew and packages from `brew/Brewfile`
2. **Node.js** - Sets up nvm and installs Node.js LTS
3. **Git Configuration** - Configures Git settings and global ignore patterns
4. **Zsh Configuration** - Sets up zsh shell configuration
5. **Cursor Configuration** - Configures Cursor editor settings and extensions
