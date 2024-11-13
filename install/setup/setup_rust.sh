#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

add_rust_path() {
    # Define Cargo paths configuration
    cargo_paths='
    # Source Cargo environment if present
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
    '

    # Check if Cargo paths are already in .profile, and add them if not
    if ! grep -q ".cargo/env" ~/.profile; then
        echo "$cargo_paths" >> ~/.profile
        print_msg "Cargo paths added to .profile."
    else
        print_msg "Cargo paths are already present in .profile."
    fi
}

install_rust() {
    print_msg "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh || { print_error "Failed to install Rust."; exit 1; }
    print_msg "Rust is installed"

}

install_rust
add_rust_path
