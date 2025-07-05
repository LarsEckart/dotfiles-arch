#!/bin/bash

echo "Setting up Git configuration..."

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create symlinks for git files
ln -sf "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$SCRIPT_DIR/.gitignore_global" "$HOME/.gitignore_global"

echo "Git configuration linked successfully!"

# Check if git is installed
if command -v git &> /dev/null; then
    echo "Current Git configuration:"
    echo "  User: $(git config --global user.name || echo 'Not set')"
    echo "  Email: $(git config --global user.email || echo 'Not set')"
    echo "  Default branch: $(git config --global init.defaultBranch)"
    echo ""
    echo "Note: You need to set your user name and email:"
    echo "  git config --global user.name \"Your Name\""
    echo "  git config --global user.email \"your.email@example.com\""
else
    echo "Git is not installed. Install it with: sudo pacman -S git"
fi