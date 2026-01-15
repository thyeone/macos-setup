#!/bin/zsh

echo "📦 Setting up Node.js with nvm..."

# Check if nvm is installed via Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "⚠️  Homebrew not found. Please install Homebrew first."
  exit 1
fi

if [ ! -s "$(brew --prefix)/opt/nvm/nvm.sh" ]; then
  echo "⚠️  nvm not found. Please install nvm first via Homebrew."
  exit 1
fi

# Setup nvm in .zshrc if not already configured
NVM_INIT_CODE='export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"'

if ! grep -q "NVM_DIR" ~/.zshrc 2>/dev/null; then
  echo "⚙️  Adding nvm configuration to ~/.zshrc..."
  echo "" >> ~/.zshrc
  echo "# nvm configuration" >> ~/.zshrc
  echo "$NVM_INIT_CODE" >> ~/.zshrc
else
  echo "✅ nvm configuration already exists in ~/.zshrc"
fi

# Load nvm in current shell session
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"

# Install LTS version if not already installed
echo "📦 Installing Node.js LTS version..."
nvm install --lts

# Use the LTS version
echo "📦 Setting LTS as default..."
nvm use --lts
nvm alias default lts/*

echo "✅ Node.js LTS setup completed!"
echo "   Current version: $(node --version)"
echo "   npm version: $(npm --version)"
