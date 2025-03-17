#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# https://github.com/Wraient/curd
install_curd() {
    print_msg "Installing curd..."

    ARCH=$(uname -m)

    curl -Lo curd https://github.com/Wraient/curd/releases/latest/download/curd-linux-$ARCH || {
        print_error "Failed to download curd."
        exit 1;
    }

    chmod +x curd || { print_error "Failed to make curd executable." exit 1; }
    sudo mv curd /usr/bin/ || { print_error "Failed to move curd to /usr/bin." exit 1; }

    print_msg "curd installation completed!"
}

install_dependencies() {
    print_msg "Installing dependencies..."

    if ! command -v curl &> /dev/null; then
        print_msg "curl is required. Installing curl..."
        sudo apt install -y curl ||{
            print_error "Failed to install curl. curl is required for installing curd."
            exit 1;
        }
        print_msg "curl installation completed!"
    fi

    if ! command -v mpv &> /dev/null; then
        print_msg "mpv is required. Installing mpv..."
        sudo apt install -y mpv || print_error "Failed to install mpv. Please install mpv manually."
        print_msg "mpv installation completed!"
    fi

    print_msg "Dependencies installation completed!"
}

install_dependencies
install_curd

