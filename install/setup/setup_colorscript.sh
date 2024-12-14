#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_colorscript() {
    if !command -v git &> /dev/null; then
        print_msg "git is required. Installing git..."
        sudo apt install -y git || print_error "Failed to install git."
        print_msg "git installation completed!"
    fi

    print_msg "Cloning colorscript repository..."
    git clone https://gitlab.com/dwt1/shell-color-scripts.git || print_error "Failed to clone colorscript repository."
    print_msg "colorscript repository cloned!"

    if !command -v make &> /dev/null; then
        print_msg "make is required. Installing make..."
        sudo apt install -y make || print_error "Failed to install make."
        print_msg "make installation completed!"
    fi

    print_msg "Installing colorscript..."
    sudo make install || print_error "Failed to install colorscript."
    print_msg "colorscript installation completed!"

    if !command -v zsh &> /dev/null; then
        print_msg "Adding colorscript completions for zsh..."
        sudo cp completions/_colorscript /usr/share/zsh/site-functions || print_error "Failed to add colorscript completions for zsh."
        print_msg "colorscript completions for zsh added!"
    fi
}

install_colorscript
