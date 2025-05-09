#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Enable necessary COPR repositories
declare -A copr_repos=(
    ["bat"]="sharkdp/bat"
    ["fzf"]="nforro/fzf"
    ["ripgrep"]="zicklag/ripgrep"
    ["zoxide"]="atim/zoxide"
)

print_msg "Enabling COPR repositories..."
for pkg in "${!copr_repos[@]}"; do
    print_msg "Enabling COPR for $pkg -> ${copr_repos[$pkg]}"
    sudo dnf copr enable -y "${copr_repos[$pkg]}"
done

# Install packages via DNF
apps=(
    arduino-cli
    bat
    bear
    btop
    eza
    fastfetch
    fd-find
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
    onefetch
    poppler-utils
    ripgrep
    p7zip
    thefuck
    tlrc
    zoxide
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
    echo "Cargo is not installed. Installing Rust (required for yazi and television)..."
    must_execute_script "setup_rust"
fi

print_msg "Installing yazi..."
if cargo install yazi-fm yazi-cli; then
    print_msg "yazi installed successfully."
else
    print_error "Failed to install yazi."
fi

if cargo install --locked television; then
    print_msg "television installed successfully."
else
    print_error "Failed to install television."
fi

print_msg "DNF setup of applications completed!"
