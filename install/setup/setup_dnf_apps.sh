#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Install packages via DNF
apps=(
  arduino-cli
  bear
  btop
  ffmpegthumbnailer
  fzf
  git-delta
  ImageMagick
  jq
  lazygit
  luarocks
  mercurial
  neovim
  nodejs
  poppler-utils
  p7zip
  tlrc
)

print_msg "Installing packages via DNF..."
sudo dnf install -y "${apps[@]}"

if ! command -v pipx &>/dev/null; then
  print_msg "Pipx is not installed. Installing pipx (required for rich-cli)..."
  must_execute_script "setup_pipx"
fi

# Install rich-cli via pip
print_msg "Installing rich-cli via pip..."
if pipx install rich-cli; then
  print_msg "rich-cli installed successfully."
else
  print_error "Failed to install rich-cli."
fi

# Install yazi and television via cargo
if ! command -v cargo &>/dev/null; then
  echo "Cargo is not installed. Installing Rust..."
  must_execute_script "setup_rust"
fi

must_execute_script "setup_cargo_apps"

for app in "${cargo_apps[@]}"; do
  print_msg "Installing $app via cargo with --locked..."
  if cargo install --locked "$app"; then
    print_msg "$app installed successfully."
  else
    print_error "Failed to install $app."
  fi
done

print_msg "DNF setup of applications completed!"
