#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_pipx() {
    print_msg "Installing pipx..."

    if command -v apt > /dev/null; then
        sudo apt install -y pipx || { print_error "Failed to install pipx."; exit 1; }
    elif command -v dnf > /dev/null; then
        sudo dnf install -y pipx || { print_error "Failed to install pipx."; exit 1; }
    else
        print_error "Unsupported package manager."
        exit 1
    fi

    pipx ensurepath || { print_error "Failed to ensure pipx path."; exit 1; }

    print_msg "pipx is installed."
}

pipx_apps() {
    if prompt_yes_default "Do you want to install pylatexenc?"; then
        pipx install pylatexenc || { print_error "Failed to install pylatexenc."; }
        print_msg "pylatexenc is installed"
    fi

    if prompt_yes_default "Do you want to install markdown formater?"
      pipx install mdformat || { print_error "Failed to install mdformat."; return 1; }
      pipx inject mdformat mdformat-myst || { print_error "Failed to inject mdformat-myst plugin."; }
      print_msg "mdformat is installed"
    fi
}

install_pipx
pipx_apps
