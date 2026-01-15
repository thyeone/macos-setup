#!/bin/zsh

echo "🚀 Starting setup..."

# Current script directory path
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Homebrew installation
# echo ""
# echo "========================================="
# echo "1. Homebrew & Packages"
# echo "========================================="
# zsh "$SCRIPT_DIR/brew/setup.sh"

# echo ""
# echo "========================================="
# echo "2. Node.js"
# echo "========================================="
# zsh "$SCRIPT_DIR/nvm/setup.sh"

# echo ""
# echo "========================================="
# echo "3. Git Configuration"
# echo "========================================="
# zsh "$SCRIPT_DIR/git/setup.sh"

# zsh
echo ""
echo "========================================="
echo "3. Zsh Configuration"
echo "========================================="
zsh "$SCRIPT_DIR/zsh/setup.sh"

echo ""
echo "✅ macOS setup completed!"
