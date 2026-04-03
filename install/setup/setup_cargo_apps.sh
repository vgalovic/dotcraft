#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Install apps that can be find only in cargo repository
install_cargo_apps() {
  print_msg "Install Cargo updater..."
  cargo install cargo-update || { print_error "Failed to install Cargo updater."; exit 1; }
  print_msg "Cargo updater is installed"

  declare -A cargo_apps=(
    [bat]="--locked"
    [caligula]=""
    [dysk]="--locked"
    [eza]=""
    [fd-find]=""
    [onefetch]="--force"
    #[ravedude]=""
    [television]=""
    [yazi-build]="--force"
  )

  for app in "${!cargo_apps[@]}"; do
    print_msg "Installing $app..."

    # Split flags safely (allows future multi-word flags)
    read -r -a flags <<< "${cargo_apps[$app]}"

    if cargo install "${flags[@]}" "$app"; then
      print_msg "$app installed successfully."
    else
      print_error "Failed to install $app."
    fi
  done
}

install_cargo_apps

