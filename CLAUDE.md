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