#!/bin/zsh

# vscode 익스텐션 txt로 추출하는법

# .cursor/extensions 디렉토리로 가서

# ```
# code|cursor --list-extensions > vscode-extensions.txt
# ```

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CURSOR_DIR="$DOTFILES_DIR/cursor"
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"

echo "📦 Setting up Cursor configuration..."

# Create Cursor User directory if it doesn't exist
mkdir -p "$CURSOR_USER_DIR"

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

# Setup settings.json
if [ -f "$CURSOR_DIR/settings.json" ]; then
  create_symlink "$CURSOR_DIR/settings.json" "$CURSOR_USER_DIR/settings.json"
else
  echo "⚠️  settings.json not found at $CURSOR_DIR/settings.json"
fi

# Install Cursor extensions from vscode-extensions.txt
if [ -f "$CURSOR_DIR/vscode-extensions.txt" ]; then
  if command -v cursor &> /dev/null; then
    echo "📦 Installing Cursor extensions..."
    xargs -n 1 cursor --install-extension < "$CURSOR_DIR/vscode-extensions.txt"
    echo "✅ Cursor extensions installation completed"
  else
    echo "⚠️  Cursor not found in PATH. Skipping extension installation."
  fi
else
  echo "⚠️  vscode-extensions.txt not found at $CURSOR_DIR/vscode-extensions.txt"
fi

echo "✅ Cursor configuration setup completed!"
