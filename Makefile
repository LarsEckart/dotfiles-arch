.PHONY: all install bash git hypr waybar scripts sudoers battery clean help

DOTFILES_DIR := $(shell pwd)
OMARCHY_CONFIG_DIR := $(HOME)/.local/share/omarchy/config

# Default target
all: help

# Install everything
install: bash git hypr waybar scripts sudoers battery
	@echo "Installation complete!"
	@echo "Please restart your shell or run: source ~/.bashrc"

# Install bash configuration
bash:
	@echo "Setting up bash configuration..."
	@# Create bash directory if it doesn't exist
	@mkdir -p $(DOTFILES_DIR)/bash
	
	@# Link bash_profile
	@if [ -f $(HOME)/.bash_profile ] && [ ! -L $(HOME)/.bash_profile ]; then \
		echo "Backing up existing .bash_profile..."; \
		mv $(HOME)/.bash_profile $(HOME)/.bash_profile.backup; \
	fi
	@ln -sf $(DOTFILES_DIR)/bash/bash_profile $(HOME)/.bash_profile
	@echo "  ✓ Linked .bash_profile"
	
	@# Link bash_history
	@if [ -f $(HOME)/.bash_history ] && [ ! -L $(HOME)/.bash_history ]; then \
		echo "Backing up existing .bash_history..."; \
		mv $(HOME)/.bash_history $(HOME)/.bash_history.backup; \
	fi
	@ln -sf $(DOTFILES_DIR)/bash/bash_history $(HOME)/.bash_history
	@echo "  ✓ Linked .bash_history"
	
	@# Add PATH export to .bashrc if not present
	@if ! grep -q "dotfiles-arch/scripts" $(HOME)/.bashrc; then \
		echo "  ✓ Adding scripts to PATH in .bashrc"; \
		echo 'export PATH="$$HOME/dotfiles-arch/scripts:$$PATH"' >> $(HOME)/.bashrc; \
	fi
	
	@# Add aliases source to .bashrc if not present
	@if ! grep -q "dotfiles-arch/bash/aliases" $(HOME)/.bashrc; then \
		echo "  ✓ Adding aliases source to .bashrc"; \
		echo '[ -f ~/dotfiles-arch/bash/aliases ] && source ~/dotfiles-arch/bash/aliases' >> $(HOME)/.bashrc; \
	fi
	
	@# Add .secrets source to .bashrc if not present
	@if ! grep -q "dotfiles-arch/.secrets" $(HOME)/.bashrc; then \
		echo "  ✓ Adding .secrets source to .bashrc"; \
		echo '[ -f ~/dotfiles-arch/.secrets ] && source ~/dotfiles-arch/.secrets' >> $(HOME)/.bashrc; \
	fi

# Install git configuration
git:
	@echo "Setting up Git configuration..."
	@# Link gitconfig
	@if [ -f $(HOME)/.gitconfig ] && [ ! -L $(HOME)/.gitconfig ]; then \
		echo "Backing up existing .gitconfig..."; \
		mv $(HOME)/.gitconfig $(HOME)/.gitconfig.backup; \
	fi
	@ln -sf $(DOTFILES_DIR)/git/.gitconfig $(HOME)/.gitconfig
	@echo "  ✓ Linked .gitconfig"
	
	@# Link gitignore_global
	@if [ -f $(HOME)/.gitignore_global ] && [ ! -L $(HOME)/.gitignore_global ]; then \
		echo "Backing up existing .gitignore_global..."; \
		mv $(HOME)/.gitignore_global $(HOME)/.gitignore_global.backup; \
	fi
	@ln -sf $(DOTFILES_DIR)/git/.gitignore_global $(HOME)/.gitignore_global
	@echo "  ✓ Linked .gitignore_global"
	
	@# Check git configuration
	@if command -v git >/dev/null 2>&1; then \
		echo ""; \
		echo "Current Git configuration:"; \
		echo "  User: $$(git config --global user.name || echo 'Not set')"; \
		echo "  Email: $$(git config --global user.email || echo 'Not set')"; \
		echo "  Default branch: $$(git config --global init.defaultBranch)"; \
		if [ -z "$$(git config --global user.name)" ] || [ -z "$$(git config --global user.email)" ]; then \
			echo ""; \
			echo "Note: You need to set your user name and email:"; \
			echo "  git config --global user.name \"Your Name\""; \
			echo "  git config --global user.email \"your.email@example.com\""; \
		fi; \
	else \
		echo ""; \
		echo "Git is not installed. Install it with: sudo pacman -S git"; \
	fi

# Install Hyprland configuration
hypr:
	@echo "Setting up Hyprland configuration..."
	@mkdir -p $(HOME)/.config/hypr
	@mkdir -p $(OMARCHY_CONFIG_DIR)/hypr
	
	@# Link hyprland.conf to ~/.config/hypr/
	@if [ -f $(HOME)/.config/hypr/hyprland.conf ] && [ ! -L $(HOME)/.config/hypr/hyprland.conf ]; then \
		echo "Backing up existing hyprland.conf..."; \
		mv $(HOME)/.config/hypr/hyprland.conf $(HOME)/.config/hypr/hyprland.conf.backup; \
	fi
	@ln -sf $(DOTFILES_DIR)/hypr/hyprland.conf $(HOME)/.config/hypr/hyprland.conf
	@echo "  ✓ Linked hyprland.conf"
	
	@# Link hypridle configuration
	@if [ -f $(OMARCHY_CONFIG_DIR)/hypr/hypridle.conf ] && [ ! -L $(OMARCHY_CONFIG_DIR)/hypr/hypridle.conf ]; then \
		echo "Backing up existing hypridle.conf..."; \
		mv $(OMARCHY_CONFIG_DIR)/hypr/hypridle.conf $(OMARCHY_CONFIG_DIR)/hypr/hypridle.conf.backup; \
	fi
	@ln -sf $(DOTFILES_DIR)/hypr/hypridle.conf $(OMARCHY_CONFIG_DIR)/hypr/hypridle.conf
	@echo "  ✓ Linked hypridle.conf"

# Install waybar configuration
waybar:
	@echo "Setting up waybar configuration..."
	@mkdir -p $(HOME)/.config/waybar
	
	@# Link waybar config
	@if [ -f $(HOME)/.config/waybar/config ] && [ ! -L $(HOME)/.config/waybar/config ]; then \
		echo "Backing up existing waybar config..."; \
		mv $(HOME)/.config/waybar/config $(HOME)/.config/waybar/config.backup; \
	fi
	@ln -sf $(DOTFILES_DIR)/waybar/config $(HOME)/.config/waybar/config
	@echo "  ✓ Linked waybar config"

# Install scripts
scripts:
	@echo "Setting up scripts..."
	@chmod +x $(DOTFILES_DIR)/scripts/*.sh
	@echo "  ✓ Made scripts executable"

# Install sudoers rule for keyboard backlight
sudoers:
	@echo "Setting up sudoers rule for keyboard backlight..."
	@if [ ! -f /etc/sudoers.d/kbd-backlight ]; then \
		echo "You may need to enter your password to create the sudoers rule:"; \
		echo "$$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/leds/smc\:\:kbd_backlight/brightness" | sudo tee /etc/sudoers.d/kbd-backlight >/dev/null; \
		sudo chmod 440 /etc/sudoers.d/kbd-backlight; \
		echo "  ✓ Created sudoers rule"; \
	else \
		echo "  ✓ Sudoers rule already exists"; \
	fi

# Install battery notifications
battery:
	@echo "Installing battery notifications..."
	@./install-battery-notifications.sh

# Remove all symlinks
clean:
	@echo "Removing symlinks..."
	@# Remove bash symlinks
	@if [ -L $(HOME)/.bash_profile ]; then \
		rm $(HOME)/.bash_profile; \
		echo "  ✓ Removed .bash_profile symlink"; \
	fi
	@if [ -L $(HOME)/.bash_history ]; then \
		rm $(HOME)/.bash_history; \
		echo "  ✓ Removed .bash_history symlink"; \
	fi
	
	@# Remove hypr symlinks
	@if [ -L $(HOME)/.config/hypr/hyprland.conf ]; then \
		rm $(HOME)/.config/hypr/hyprland.conf; \
		echo "  ✓ Removed hyprland.conf symlink"; \
	fi
	@if [ -L $(OMARCHY_CONFIG_DIR)/hypr/hypridle.conf ]; then \
		rm $(OMARCHY_CONFIG_DIR)/hypr/hypridle.conf; \
		echo "  ✓ Removed hypridle.conf symlink"; \
	fi
	
	@# Remove waybar symlinks
	@if [ -L $(HOME)/.config/waybar/config ]; then \
		rm $(HOME)/.config/waybar/config; \
		echo "  ✓ Removed waybar config symlink"; \
	fi
	
	@# Remove git symlinks
	@if [ -L $(HOME)/.gitconfig ]; then \
		rm $(HOME)/.gitconfig; \
		echo "  ✓ Removed .gitconfig symlink"; \
	fi
	@if [ -L $(HOME)/.gitignore_global ]; then \
		rm $(HOME)/.gitignore_global; \
		echo "  ✓ Removed .gitignore_global symlink"; \
	fi
	
	@# Restore backups if they exist
	@if [ -f $(HOME)/.bash_profile.backup ]; then \
		mv $(HOME)/.bash_profile.backup $(HOME)/.bash_profile; \
		echo "  ✓ Restored .bash_profile from backup"; \
	fi
	@if [ -f $(HOME)/.bash_history.backup ]; then \
		mv $(HOME)/.bash_history.backup $(HOME)/.bash_history; \
		echo "  ✓ Restored .bash_history from backup"; \
	fi
	@if [ -f $(HOME)/.config/hypr/hyprland.conf.backup ]; then \
		mv $(HOME)/.config/hypr/hyprland.conf.backup $(HOME)/.config/hypr/hyprland.conf; \
		echo "  ✓ Restored hyprland.conf from backup"; \
	fi
	@if [ -f $(OMARCHY_CONFIG_DIR)/hypr/hypridle.conf.backup ]; then \
		mv $(OMARCHY_CONFIG_DIR)/hypr/hypridle.conf.backup $(OMARCHY_CONFIG_DIR)/hypr/hypridle.conf; \
		echo "  ✓ Restored hypridle.conf from backup"; \
	fi
	@if [ -f $(HOME)/.gitconfig.backup ]; then \
		mv $(HOME)/.gitconfig.backup $(HOME)/.gitconfig; \
		echo "  ✓ Restored .gitconfig from backup"; \
	fi
	@if [ -f $(HOME)/.gitignore_global.backup ]; then \
		mv $(HOME)/.gitignore_global.backup $(HOME)/.gitignore_global; \
		echo "  ✓ Restored .gitignore_global from backup"; \
	fi
	@if [ -f $(HOME)/.config/waybar/config.backup ]; then \
		mv $(HOME)/.config/waybar/config.backup $(HOME)/.config/waybar/config; \
		echo "  ✓ Restored waybar config from backup"; \
	fi

# Help target
help:
	@echo "Dotfiles Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install   - Install all configurations (bash, git, hypr, waybar, scripts, sudoers, battery)"
	@echo "  bash      - Install bash configuration files"
	@echo "  git       - Install git configuration files"
	@echo "  hypr      - Install Hyprland configuration"
	@echo "  waybar    - Install waybar configuration"
	@echo "  scripts   - Make scripts executable"
	@echo "  sudoers   - Install sudoers rule for keyboard backlight"
	@echo "  battery   - Install battery notification system"
	@echo "  clean     - Remove all symlinks and restore backups"
	@echo "  help      - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make install     # Install everything"
	@echo "  make bash        # Install only bash configuration"
	@echo "  make git         # Install only git configuration"
	@echo "  make clean       # Remove all symlinks"