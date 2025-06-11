#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

print_msg "Updating system packages..."
sudo pacman -Syu --noconfirm || { print_error "Failed to update system packages."; exit 1; }

print_msg "Checking for base-devel..."
pacman -Q base-devel &>/dev/null || {
  print_msg "Installing base-devel..."
  sudo pacman -S --noconfirm base-devel || { print_error "Failed to install base-devel."; exit 1; }
}

print_msg "Checking for git..."
pacman -Q git &>/dev/null || {
  print_msg "Installing git..."
  sudo pacman -S --noconfirm git || { print_error "Failed to install git."; exit 1; }
}

tmp_dir=$(mktemp -d)
cd "$tmp_dir" || { print_error "Failed to enter temp directory."; exit 1; }

print_msg "Cloning yay from AUR..."
git clone https://aur.archlinux.org/yay.git || { print_error "Failed to clone yay repository."; exit 1; }

cd yay || { print_error "Failed to enter yay directory."; exit 1; }

print_msg "Building and installing yay..."
makepkg -si --noconfirm || { print_error "Failed to build and install yay."; exit 1; }

cd || { print_error "Failed to return to home directory."; exit 1; }
rm -rf "$tmp_dir" || { print_error "Failed to remove temporary directory."; exit 1; }

print_msg "yay has been installed successfully!"
