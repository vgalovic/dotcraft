#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_npm() {
    print_msg "Installing npm..."
    if ! command -v npm &> /dev/null; then
        sudo apt install nodejs npm || {
            print_error "Failed to install npm."
            exit 1
        }
        print_msg "npm installed successfully."
    }
}

install_mermaid() {
    print_msg "Installing mermaid..."
    npm install -g @mermaid-js/mermaid-cli|| {
        print_error "Failed to install mermaid."
        exit 1
    }
    print_msg "mermaid installed successfully."
}

install_npm

if prompt_yes_default "Do you want to install mermaid?"; then
    install_mermaid
fi
