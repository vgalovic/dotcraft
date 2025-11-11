#!/bin/bash
set -euo pipefail

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

print_msg "Installing GitHub CLI (gh)..."

# Ensure wget is installed
if ! command -v wget >/dev/null 2>&1; then
    print_msg "Installing wget..."
    sudo apt update -y
    sudo apt install wget -y || { print_error "Failed to install wget."; exit 1; }
fi

# Create keyrings directory
sudo mkdir -p -m 755 /etc/apt/keyrings

# Download GitHub CLI GPG key
temp_key=$(mktemp)
print_msg "Downloading GitHub CLI GPG key..."
if ! wget -qO "$temp_key" https://cli.github.com/packages/githubcli-archive-keyring.gpg; then
    print_error "Failed to download GitHub CLI GPG key."
    rm -f "$temp_key"
    exit 1
fi

# Install key and clean up temp
sudo install -m 644 "$temp_key" /etc/apt/keyrings/githubcli-archive-keyring.gpg
rm -f "$temp_key"

# Add GitHub CLI repository if missing
repo_file="/etc/apt/sources.list.d/github-cli.list"
if ! grep -q "cli.github.com/packages" "$repo_file" 2>/dev/null; then
    print_msg "Adding GitHub CLI APT source..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
        sudo tee "$repo_file" > /dev/null
else
    print_msg "GitHub CLI APT source already exists."
fi

# Update package index
print_msg "Updating package index..."
sudo apt update -y || { print_error "Failed to update APT sources."; exit 1; }

# Install gh if not already installed
if ! command -v gh >/dev/null 2>&1; then
    print_msg "Installing GitHub CLI..."
    sudo apt install gh -y || { print_error "Failed to install GitHub CLI."; exit 1; }
else
    print_msg "GitHub CLI is already installed."
fi

print_msg "GitHub CLI installation complete!"

