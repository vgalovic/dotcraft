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

    print_msg "Downloading yt-dlp binary..."
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp || print_error "Failed to download yt-dlp binary."
    sudo chmod a+rx /usr/local/bin/yt-dlp || print_error "Failed to set permissions for yt-dlp binary."
    print_msg "yt-dlp binary downloaded!"

    # Install ani-cli dependencies
    print_msg "Installing ani-cli and other dependencies..."
    sudo apt install -y grep sed aria2 ffmpeg || print_error "Failed to install ani-cli dependencies."
    print_msg "ani-cli and other dependencies installed!"
}

install_ani-cli
