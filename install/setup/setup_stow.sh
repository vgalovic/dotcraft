#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Define your dotfiles directory
STOW_DIR="$HOME/.dotfiles/config"

# Check if GNU Stow is installed
if ! command -v stow &> /dev/null; then
    print_msg "Installing GNU Stow..."
    sudo apt install stow || { print_error "Failed to install GNU Stow."; exit 1; }
    print_msg "GNU Stow installed"
fi

# Check if the dotfiles directory exists
if [ ! -d "$STOW_DIR" ]; then
    print_error "Dotfiles directory $STOW_DIR does not exist."
    exit 1
fi

# Backup existing config files
backup_files() {
    print_msg "Backing up existing config files..."

    backup_file() {
        local file=$1
        local backup=$2
        if [ -f "$file" ]; then
            mv "$file" "$backup"
            print_msg "$file backup completed."
        else
            print_msg "$file not found, skipping backup."
        fi
    }

    backup_file "$HOME/.bashrc" "$HOME/.bashrc.old"
    backup_file "$HOME/.profile" "$HOME/.profile.old"
    backup_file "$HOME/.gitconfig" "$HOME/.gitconfig.old"    

    for config in bat btop conky kitty fastfetch lazygit mpv nvim yazi zed; do
        config_dir="$HOME/.config/$config"
        if [ -d "$config_dir" ]; then
            mv "$config_dir" "$config_dir.old"
            print_msg "$config config backup completed."
        else
            print_msg "$config config directory not found, skipping backup."
        fi
    done

    backup_file "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.old"
}

# Stow files from dotfiles directory
stow_files() {
    cd "$STOW_DIR" || exit 1

    # Stow the dotfiles with absolute path
    if stow -d "$STOW_DIR" -t "$HOME" .; then
        print_msg "Dotfiles stowed successfully."
    else
        print_error "Failed to stow dotfiles."
        exit 1
    fi
}

source_files() {
    cd ~

    # Check if .profile exists before sourcing
    if [ -f .profile ]; then
        print_msg "Sourcing profile..."
        source .profile
    else
        print_error ".profile not found, skipping sourcing."
    fi

    # Check if .bashrc exists before sourcing
    if [ -f .bashrc ]; then
        print_msg "Sourcing bash..."
        source .bashrc
    else
        print_error ".bashrc not found, skipping sourcing."
    fi
}

backup_files
stow_files
source_files
