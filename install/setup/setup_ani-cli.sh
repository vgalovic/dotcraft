#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_ani-cli() {
    print_msg "Installing ani-cli..."

    # Ensure mpv is installed
    if ! command -v mpv &> /dev/null; then
        print_msg "mpv is required. Installing mpv..."
        sudo apt install -y mpv || print_error "Failed to install mpv."
        print_msg "mpv installation completed!"
    fi
   
    # Ensure fzf is installed
    if ! command -v fzf &> /dev/null; then
        print_msg "fzf is required. Installing fzf..."
        sudo apt install -y fzf || print_error "Failed to install fzf."
        print_msg "fzf installation completed!"
    fi

    # Install ani-cli dependencies
    sudo apt install -y grep sed aria2 yt-dlp ffmpeg || print_error "Failed to install ani-cli dependencies."
    print_msg "ani-cli installation completed!"
}

install_ani-cli
