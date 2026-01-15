#!/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GIT_DIR="$DOTFILES_DIR/git"
HOME_DIR="$HOME"

echo "📦 Setting up Git configuration..."

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

# Setup .gitconfig
if [ -f "$GIT_DIR/.gitconfig" ]; then
  create_symlink "$GIT_DIR/.gitconfig" "$HOME_DIR/.gitconfig"
else
  echo "⚠️  .gitconfig not found at $GIT_DIR/.gitconfig"
fi

# Setup .gitignore
if [ -f "$GIT_DIR/.gitignore" ]; then
  create_symlink "$GIT_DIR/.gitignore" "$HOME_DIR/.gitignore"
  # Configure git to use .gitignore as global excludes file
  echo "⚙️  Configuring git to use .gitignore as global excludes file..."
  git config --global core.excludesFile ~/.gitignore
else
  echo "⚠️  .gitignore not found at $GIT_DIR/.gitignore"
fi

echo "✅ Git configuration setup completed!"
