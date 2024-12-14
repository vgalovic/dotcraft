#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_uosc() {
    if prompt_yes_default "Do you want to install uosc (mpv skin)?"; then
        print_msg "Downloading uosc..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh)" \
        && print_msg "uosc installed successfully." \
        || print_error "Failed to download uosc"
    fi
}

install_thumbfast() {
    if prompt_yes_default "Do you want to install thumbfast (thumbnailer) for mpv?"; then
        print_msg "Downloading thumbfast..."
        git clone https://github.com/po5/thumbfast.git || { print_error "Failed to download thumbfast"; return 1; }

        cd thumbfast || { print_error "Failed to change directory to thumbfast"; return 1; }

        mv thumbfast.lua ~/.config/mpv/scripts/thumbfast.lua || { print_error "Failed to move thumbfast.lua"; return 1; }
        mv thumbfast.conf ~/.config/mpv/script-opts/thumbfast.conf || { print_error "Failed to move thumbfast.conf"; return 1; }

        cd ..
        rm -rf thumbfast || print_error "Failed to remove thumbfast directory"
        print_msg "Thumbfast installed successfully."
    fi
}

# Check and prepare mpv configuration directories
if [ -d ~/.config/mpv/scripts ]; then
    print_msg "mpv scripts directory already exists. Removing old directory..."
    rm -rf ~/.config/mpv/scripts || print_error "Failed to remove mpv scripts directory"
fi

if [ -d ~/.config/mpv/script-opts ]; then
    print_msg "mpv script-opts directory already exists. Removing old directory..."
    rm -rf ~/.config/mpv/script-opts || print_error "Failed to remove mpv script-opts directory"
fi

mkdir -p ~/.config/mpv/scripts
mkdir -p ~/.config/mpv/script-opts

# Call installation functions
install_uosc
install_thumbfast

