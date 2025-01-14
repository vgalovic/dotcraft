#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Define your dotfiles directory
STOW_DIR="$HOME/.dotfiles/home"
STOW_LIST="$HOME/.dotfiles/install/stow_list"
CONFIG="$HOME/.config"

# Load file lists from external text files
HOME_FILES_TXT="$STOW_LIST/home_files.txt"
CONFIG_DIRS_TXT="$STOW_LIST/config_dirs.txt"
CONFIG_FILES_TXT="$STOW_LIST/config_files.txt"

# Check if file exists and load it into an array
load_list() {
    local file=$1
    local -n array=$2
    if [ -f "$file" ]; then
        readarray -t array < "$file"
    else
        print_error "File $file not found. Exiting."
        exit 1
    fi
}

# Load arrays from text files
load_list "$HOME_FILES_TXT" home_files || { print_error "Failed to load home files."; exit 1; }
load_list "$CONFIG_DIRS_TXT" config_dirs || { print_error "Failed to load config dirs."; exit 1; }
load_list "$CONFIG_FILES_TXT" config_files || { print_error "Failed to load config files."; exit 1; }

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

    backup() {
        local check=$1
        local file=$2
        local backup=$3
        if [ "$check" "$file" ]; then
            mv "$file" "$backup.old"
            print_msg "$file backup completed."
        else
            print_msg "$file not found, skipping backup."
        fi
    }

    # Backup home config files
    for file in "${home_files[@]}"; do
        backup "-f" "$HOME/$file" "$HOME/$file"
    done

    # Backup .config directory files
    for dir in "${config_dirs[@]}"; do
        backup "-d" "$CONFIG/$dir" "$CONFIG/$dir"
    done

    # Backup standalone config files
    for file in "${config_files[@]}"; do
        backup "-f" "$CONFIG/$file" "$CONFIG/$file"
    done
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

remove_old_config() {
    print_msg "Removing old config files..."
    for file in "${home_files[@]}"; do
        rm -f "$HOME/$file.old" || print_error "Failed to remove $file.old."
    done

    for dir in "${config_dirs[@]}"; do
        rm -rf "$CONFIG/$dir.old" || print_error "Failed to remove $dir.old."
    done

    for file in "${config_files[@]}"; do
        rm -f "$CONFIG/$file.old" || print_error "Failed to remove $file.old."
    done

    print_msg "Old config files removed."
}

backup_files
stow_files

if prompt_yes_default "Do you want to remove old config files?[Y/n]"; then
    remove_old_config
fi

print_msg "Stowing dotfiles completed. Please restart your terminal for changes to take effect."

