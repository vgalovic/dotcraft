#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

zathura_dir="$HOME/.config/zathura"

download_zathura_theme_file() {
    print_msg "Downloading Catppuccin Mocha theme file..."
    wget -P $zathura_dir https://raw.githubusercontent.com/catppuccin/zathura/refs/heads/main/src/catppuccin-mocha || print_error "Failed to download Catppuccin Mocha theme file."
}

download_zathura_theme_file
