#!/bin/zsh

# Current script directory path
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check for --all flag
INSTALL_ALL=false
if [[ "$1" == "--all" ]]; then
  INSTALL_ALL=true
fi

# Function to prompt user for confirmation
prompt_install() {
  local name="$1"
  local script="$2"
  
  if [ "$INSTALL_ALL" = true ]; then
    return 0
  fi
  
  echo ""
  read "?Install $name? (y/n): " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

# Function to run setup script
run_setup() {
  local name="$1"
  local script="$2"
  
  echo ""
  echo "========================================="
  echo "$name"
  echo "========================================="
  zsh "$script"
}

echo "🚀 Starting setup..."

# Homebrew installation
if prompt_install "Homebrew & Packages" "$SCRIPT_DIR/brew/setup.sh"; then
  run_setup "1. Homebrew & Packages" "$SCRIPT_DIR/brew/setup.sh"
fi

# Node.js installation
if prompt_install "Node.js" "$SCRIPT_DIR/nvm/setup.sh"; then
  run_setup "2. Node.js" "$SCRIPT_DIR/nvm/setup.sh"
fi

# Git Configuration
if prompt_install "Git Configuration" "$SCRIPT_DIR/git/setup.sh"; then
  run_setup "3. Git Configuration" "$SCRIPT_DIR/git/setup.sh"
fi

# Zsh Configuration
if prompt_install "Zsh Configuration" "$SCRIPT_DIR/zsh/setup.sh"; then
  run_setup "4. Zsh Configuration" "$SCRIPT_DIR/zsh/setup.sh"
fi

# Cursor Configuration
if prompt_install "Cursor Configuration" "$SCRIPT_DIR/cursor/setup.sh"; then
  run_setup "5. Cursor Configuration" "$SCRIPT_DIR/cursor/setup.sh"
fi

echo ""
echo "✅ macOS setup completed!"
