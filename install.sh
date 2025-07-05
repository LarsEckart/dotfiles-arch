#!/bin/bash
# Install script for dotfiles-arch

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OMARCHY_CONFIG_DIR="$HOME/.local/share/omarchy/config"

echo "Installing dotfiles-arch configuration..."

# Create necessary directories
mkdir -p "$OMARCHY_CONFIG_DIR/hypr"

# Link hypridle configuration
if [[ -f "$OMARCHY_CONFIG_DIR/hypr/hypridle.conf" ]]; then
    echo "Backing up existing hypridle.conf..."
    mv "$OMARCHY_CONFIG_DIR/hypr/hypridle.conf" "$OMARCHY_CONFIG_DIR/hypr/hypridle.conf.backup"
fi

echo "Linking hypridle configuration..."
ln -sf "$DOTFILES_DIR/hypr/hypridle.conf" "$OMARCHY_CONFIG_DIR/hypr/hypridle.conf"

# Add scripts to PATH via bashrc
if ! grep -q "dotfiles-arch/scripts" "$HOME/.bashrc"; then
    echo "Adding dotfiles-arch/scripts to PATH..."
    echo 'export PATH="$HOME/dotfiles-arch/scripts:$PATH"' >> "$HOME/.bashrc"
fi

# Create sudoers rule for keyboard backlight (optional)
SUDOERS_FILE="/etc/sudoers.d/kbd-backlight"
if [[ ! -f "$SUDOERS_FILE" ]]; then
    echo "Creating sudoers rule for keyboard backlight..."
    echo "You may need to enter your password to create the sudoers rule:"
    echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/leds/smc::kbd_backlight/brightness" | sudo tee "$SUDOERS_FILE" >/dev/null
    sudo chmod 440 "$SUDOERS_FILE"
fi

# Install git configuration
if [[ -x "$DOTFILES_DIR/git/install.sh" ]]; then
    echo ""
    "$DOTFILES_DIR/git/install.sh"
fi

echo ""
echo "Installation complete!"
echo "Please restart hypridle or reboot to apply the new configuration:"
echo "  killall hypridle && hypridle &"