#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to install Kitty terminal
install_kitty() {
  print_msg "Installing Kitty terminal..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin || { print_error "Failed to install Kitty terminal"; }

  # Set up directories and symlinks for Kitty
  mkdir -p ~/.local/bin/ || { print_error "Failed to create ~/.local/bin/ directory"; }
  mkdir -p ~/.local/share/applications/ || { print_error "Failed to create ~/.local/share/applications/ directory"; }
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/ || { print_error "Failed to create symlink for kitty"; }
  ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/ || { print_error "Failed to create symlink for kitten"; }
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/ || { print_error "Failed to copy kitty.desktop"; }
  cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/ || { print_error "Failed to copy kitty-open.desktop"; }
  sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop || { print_error "Failed to update icon path in kitty.desktop"; }
  sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop || { print_error "Failed to update exec path in kitty.desktop"; }
  echo 'kitty.desktop' > ~/.config/xdg-terminals.list || { print_error "Failed to create xdg-terminals list"; }
}

# Function to install Starship prompt
install_starship() {
  print_msg "Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh || { print_error "Failed to install Starship prompt"; }
}

install_kitty
install_starship
