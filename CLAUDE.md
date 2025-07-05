# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for an Arch Linux system running omarchy. The repository contains customizations that extend/override omarchy defaults without causing conflicts during system updates.

## Architecture

- **bash/aliases** - Custom bash aliases that are loaded after omarchy defaults
- Aliases are automatically sourced by `~/.bashrc` after omarchy's defaults
- The repository uses git tracking separate from omarchy to prevent conflicts

## Development Workflow

### Adding New Aliases
- Add custom aliases to `bash/aliases`
- Aliases will override omarchy defaults if they have the same name
- No build or compilation steps required - changes take effect after sourcing

### Testing Changes
- Source the aliases file: `source bash/aliases`
- Or reload your shell session to test new aliases

## Key Files

- `bash/aliases` - Main aliases file where all customizations go
- `README.md` - Documentation for the repository structure and usage

## Notes

- This repository is designed to work alongside omarchy without conflicts
- Changes are immediately effective after sourcing or reloading the shell
- The repository includes a Claude CLI shortcut: `ccd` for `claude --dangerously-skip-permissions`