#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

remove_old_glow_theme() {
    if [ -d $HOME/.config/glow/themes ]; then
        print_msg "Removing old glow themes directory..."
        rm -rf $HOME/.config/glow/themes || { print_error "Could not remove old glow themes directory"; exit 1; }
    fi

    mkdir -p $HOME/.config/glow/themes || { print_error "Could not create glow themes directory"; exit 1; }
}

download_glow_theme() {
    print_msg "Downloading glow-extras..."
    cd $HOME/.config/glow/themes || { print_error "Could not cd to glow themes directory"; exit 1; }
    wget https://raw.githubusercontent.com/catppuccin/glamour/refs/heads/main/themes/catppuccin-mocha.json || print_error "Could not download CattPuccin Mocha theme for Glow"

}

remove_old_glow_theme
download_glow_theme
