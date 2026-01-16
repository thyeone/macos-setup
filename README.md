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

The script will automatically:

- Install Homebrew (if not already installed)
- Install packages from `brew/Brewfile`
- Set up Node.js LTS via nvm
- Configure Git settings
- Set up zsh configuration
- Configure Cursor editor settings and extensions
