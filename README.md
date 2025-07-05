# Personal Dotfiles for Arch Linux

This repository contains personal dotfiles and customizations for my Arch Linux system running omarchy.

## Structure

- `bash/aliases` - Custom bash aliases that extend/override omarchy defaults

## Usage

The dotfiles are automatically sourced by `~/.bashrc` after the omarchy defaults, allowing for customization without conflicts.

## Adding New Aliases

Add your custom aliases to `bash/aliases`. They will be loaded after omarchy's defaults and can override them if needed.

Example:
```bash
# Add to bash/aliases
alias ll='ls -la'
alias myserver='ssh user@myserver.com'
```

## Git Tracking

This repository is git-tracked separately from omarchy, preventing conflicts during omarchy updates while maintaining version control of personal customizations.