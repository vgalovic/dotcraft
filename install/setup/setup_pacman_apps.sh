#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

print_msg "Updating system via pacman..."
sudo pacman -Syu --noconfirm

# Official packages via pacman
pacman_apps=(
  arduino-cli
  bat
  bear
  btop
  eza
  fastfetch
  fd
  ffmpegthumbnailer
  fzf
  git-delta
  imagemagick
  jq
  luarocks
  mercurial
  neovim
  nodejs
  onefetch
  poppler
  ripgrep
  p7zip
  thefuck
)

print_msg "Installing official packages via pacman..."
sudo pacman -S --needed --noconfirm "${pacman_apps[@]}"

# Check if yay is installed
if ! command -v yay &>/dev/null; then
  print_warn "yay not found, installing via setup_yay.sh..."
  must_execute_script "setup_yay"
fi

# AUR packages via yay
aur_apps=(
  lazygit
  rich-cli
  tlrc
  yazi
  television
)

print_msg "Installing AUR packages via yay..."
yay -S --needed --noconfirm "${aur_apps[@]}"

print_msg "All applications installed successfully for Arch-based system."
