#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

print_msg "Updating APT package list..."
sudo apt update

print_msg "Adding required external repositories..."

# Node.js 20.x from NodeSource
print_msg "Adding Node.js 20.x source..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# Fastfetch PPA
if ! grep -q "^deb .*\zhangsongcui3371/fastfetch" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
  print_msg "Adding PPA for Fastfetch..."
  sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
fi

# Update package list after adding sources
sudo apt update

# APT installable packages
apps=(
  bear
  btop
  delta
  fastfetch
  ffmpegthumbnailer
  fzf
  imagemagick
  jq
  luarocks
  mercurial
  nodejs
  p7zip-full
  poppler-utils
  ripgrep
)

print_msg "Installing packages via APT..."
sudo apt install -y "${apps[@]}"

# Install pipx if not installed
if ! command -v pipx &>/dev/null; then
  print_msg "pipx is not installed. Installing pipx (required for rich-cli)..."
  must_execute_script "setup_pipx"
fi

print_msg "Installing rich-cli via pipx..."
if pipx install rich-cli; then
  print_msg "rich-cli installed successfully."
else
  print_error "Failed to install rich-cli."
fi

# Install cargo if missing (Rust toolchain)
if ! command -v cargo &>/dev/null; then
  print_msg "Cargo is not installed. Installing Rust (required for some packages)..."
  must_execute_script "setup_rust"
fi

# Cargo-based tools
cargo_apps=(
  bat
  eza
  fd-find
  onefetch
  television
  tlrc
  yazi-cli
  yazi-fm
)

for app in "${cargo_apps[@]}"; do
  print_msg "Installing $app via cargo with --locked..."
  if cargo install --locked "$app"; then
    print_msg "$app installed successfully."
  else
    print_error "Failed to install $app."
  fi
done

# Install Github cli
execute_script "setup_github_cli"

# Install latest Neovim from GitHub releases
must_execute_script "setup_neovim"

# Install latest lazygit from GitHub releases
must_execute_script "setup_lazygit"

# Install arduino-cli to ~/local/bin
print_msg "Installing arduino-cli..."
mkdir -p $HOME/.local/bin/
if curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR="$HOME/.local/bin" sh; then
  print_msg "arduino-cli installed successfully to ~/local/bin."
else
  print_error "Failed to install arduino-cli."
fi

# Install latest Neovim from source using your setup script
print_msg "Installing latest Neovim from source..."
"$HOME/.dotfiles/install/setup/setup_neovim.sh"
print_msg "Latest Neovim installation completed."

print_msg "APT-based setup of applications completed!"
