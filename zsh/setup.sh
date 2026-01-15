#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ZSH_DIR="$DOTFILES_DIR/zsh"
HOME_DIR="$HOME"

echo "📦 Setting up zsh configuration..."

# Function to create symlink, backing up existing file if needed
create_symlink() {
  local source_file="$1"
  local target_file="$2"
  local file_name=$(basename "$source_file")

  if [ -L "$target_file" ]; then
    echo "⚠️  Removing existing symlink: $target_file"
    rm "$target_file"
  elif [ -f "$target_file" ]; then
    echo "⚠️  Backing up existing file: $target_file -> ${target_file}.backup"
    mv "$target_file" "${target_file}.backup"
  fi

  echo "🔗 Creating symlink: $target_file -> $source_file"
  ln -s "$source_file" "$target_file"
}

# Setup .zshrc
if [ -f "$ZSH_DIR/.zshrc" ]; then
  create_symlink "$ZSH_DIR/.zshrc" "$HOME_DIR/.zshrc"
else
  echo "⚠️  .zshrc not found at $ZSH_DIR/.zshrc"
fi

echo "✅ zsh configuration setup completed!"
