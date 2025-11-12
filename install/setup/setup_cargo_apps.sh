#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Install apps that can be find only in cargo repository
install_cargo_apps() {
  print_msg "Install Cargo updater..."
  cargo install cargo-update || { print_error "Failed to install Cargo updater."; exit 1; }
  print_msg "Cargo updater is installed"

  cargo_apps=(
    caligula
    dysk
    ravedude
  )

  if command -v apt >/dev/null 2>&1 && ! command -v brew >/dev/null 2>&1; then
    cargo_apps+=(
      bat
      eza
      fd-find
      television
      yazi-build
      yazi-cli
      yazi-fm
    )
  fi

  for app in "${cargo_apps[@]}"; do
    print_msg "Installing $app..."
    if cargo install "$app"; then
      print_msg "$app installed successfully."
    else
      print_error "Failed to install $app."
    fi
  done
}

install_cargo_apps

