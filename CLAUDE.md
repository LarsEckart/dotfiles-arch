# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for an Arch Linux system running omarchy. The repository contains customizations that extend/override omarchy defaults without causing conflicts during system updates.

### Core Philosophy

The fundamental approach is:
1. **All configuration lives in this repository** - No direct editing of system config files
2. **Symlink everything** - Configuration files are symlinked from this repo to where the system expects them
3. **Omarchy first, customizations second** - Always source omarchy defaults first, then layer customizations on top
4. **Non-destructive** - The Makefile backs up existing configs before creating symlinks

This ensures clean separation between omarchy's base configuration and personal customizations, making updates seamless and configurations portable.

## How to Override Without Losing Changes

Understanding omarchy's file structure is crucial for safe customization:

- **`~/.config/`** - Your customization files (safe from updates, considered YOUR files)
- **`~/.local/share/omarchy/`** - Omarchy's internal files (don't edit directly, will be overwritten during updates)

### Best Practices

1. **Never edit files in `~/.local/share/omarchy/` directly**
   - Changes there will be overwritten during omarchy updates
   - If updates do touch them, your changes are saved to `.bak` files

2. **Always put customizations in `~/.config/`**
   - These files are protected from omarchy updates
   - Override omarchy defaults by setting values here
   - This repository symlinks to these safe locations

3. **Use the Omarchy Menu for config edits**
   - Press `Super + Alt + Space` → Setup > Configs > [process]
   - Opens configs in Neovim and auto-restarts processes after saving
   - Ensures proper reload handling

### Key Override Locations

- `~/.config/hypr/hyprland.conf` - Hyprland keybindings and settings
- `~/.config/hypr/input.conf` - Keyboard/mouse/trackpad configuration
- `~/.config/waybar/config.jsonc` - Status bar configuration
- `~/.config/starship.toml` - Shell prompt customization
- `~/.bashrc` - Bash configuration (home directory)

### Recovery Options

- **Individual config restore**: `Super + Alt + Space` → Update > Config
- **Full reset**: Run `omarchy-reinstall` to restore all defaults

## Architecture

- **bash/** - Bash configuration files
  - `aliases` - Custom bash aliases that are loaded after omarchy defaults
  - `bashrc` - Main bash configuration that sources omarchy defaults and custom configs
  - `bash_profile` - Bash profile configuration
  - `bash_history` - Shared bash history
  - `prompt` - Custom prompt configuration
- **git/** - Git configuration files
  - `.gitconfig` - Git configuration
  - `.gitignore_global` - Global gitignore patterns
  - `install.sh` - Git installation script
- **hypr/** - Hyprland window manager configuration
  - `hyprland.conf` - Main Hyprland configuration
  - `hypridle.conf` - Idle daemon configuration
- **scripts/** - Utility scripts
  - `kbd-backlight.sh` - MacBook keyboard backlight control
- **Makefile** - Installation and management automation
- **keyboard-layout.md** - Documentation for keyboard layout configuration
- The repository uses git tracking separate from omarchy to prevent conflicts

## Development Workflow

### Installation
- Run `make install` to install all configurations
- Or install specific components: `make bash`, `make git`, `make hypr`, etc.
- Run `make clean` to remove all symlinks and restore backups

### Adding New Aliases
- Add custom aliases to `bash/aliases`
- Aliases will override omarchy defaults if they have the same name
- No build or compilation steps required - changes take effect after sourcing

### Testing Changes
- Source the aliases file: `source bash/aliases`
- Or reload your shell session to test new aliases

### Managing Configurations
- Bash files are symlinked from the repository
- Git configurations are symlinked to home directory
- Hyprland configs are symlinked to appropriate config directories
- Scripts are automatically made executable

### Configuration Loading Order
1. **bashrc**: Sources `~/.local/share/omarchy/default/bash/rc` first
2. Then adds custom PATH for scripts
3. Then sources custom aliases and prompt
4. This ensures omarchy defaults are always loaded before customizations

## Key Files

- `bash/aliases` - Main aliases file where all customizations go
- `bash/bashrc` - Custom bashrc that sources omarchy defaults and dotfiles configs
- `Makefile` - Automated installation and management
- `scripts/kbd-backlight.sh` - Keyboard backlight control for MacBook
- `hypr/hyprland.conf` - Custom Hyprland window manager configuration
- `README.md` - Documentation for the repository structure and usage

## Notes

- This repository is designed to work alongside omarchy without conflicts
- Changes are immediately effective after sourcing or reloading the shell
- The repository includes a Claude CLI shortcut: `ccd` for `claude --dangerously-skip-permissions`
- The bashrc sources omarchy defaults first, then adds custom PATH for scripts
- Custom prompt and aliases are loaded after omarchy defaults
- Makefile handles backups of existing files during installation
- Sudoers rule can be installed for passwordless keyboard backlight control