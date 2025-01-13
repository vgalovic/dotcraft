#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

pipx_install() {
    print_msg "Installing pipx..."
    sudo apt install pipx || { print_error "Failed to install pipx."; exit 1; }
    sudo pipx ensurepath --global || { print_error "Failed to ensure pipx path."; }
    sudo pipx ensurepath --prepend || { print_error "Failed to ensure pipx path."; }
    print_msg "pipx is installed"
}

pipx_apps() {
    if prompt_yes_default "Do you want to install pylatexenc?"; then
        pipx install pylatexenc || { print_error "Failed to install pylatexenc."; }
        print_msg "pylatexenc is installed"
    fi
}

pipx_install
pipx_apps
