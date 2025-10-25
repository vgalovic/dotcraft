#!/bin/bash

set -e

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Fetch latest version from GitHub
print_msg "Fetching latest lazygit version..."
LAZYGIT_VERSION=$(curl -sf "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
  | grep -Po '"tag_name": *"v\K[^"]*') || {
    print_error "Failed to fetch latest lazygit version"
    exit 1
  }

# Check if lazygit is already installed
if command -v lazygit &> /dev/null; then
  INSTALLED_VERSION=$(lazygit --version | grep -oP 'version=\K[^,]+' | head -1) || {
    print_error "Failed to parse installed lazygit version"
    exit 1
  }
  echo "Installed version: $INSTALLED_VERSION"
  echo "Latest version:    $LAZYGIT_VERSION"

  if [ "$INSTALLED_VERSION" = "$LAZYGIT_VERSION" ]; then
    print_msg "Lazygit is already up to date."
    exit 0
  else
    print_msg "Updating lazygit from $INSTALLED_VERSION to $LAZYGIT_VERSION..."

    LAZYGIT_PATH=$(command -v lazygit)
    print_msg "Removing old version from: $LAZYGIT_PATH"
    if [ -w "$LAZYGIT_PATH" ]; then
      rm -f "$LAZYGIT_PATH" || {
        print_error "Failed to remove old lazygit binary"
        exit 1
      }
    else
      sudo rm -f "$LAZYGIT_PATH" || {
        print_error "Failed to remove old lazygit binary with sudo"
        exit 1
      }
    fi
  fi
else
  print_msg "Lazygit is not installed. Installing version $LAZYGIT_VERSION..."
fi

# Download the tarball
print_msg "Downloading lazygit tarball"
curl -fLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" || {
  print_error "Failed to download lazygit tarball"
  exit 1
}

# Extract the binary
print_msg "Extracting lazygit binary"
tar xf lazygit.tar.gz lazygit || {
  print_error "Failed to extract lazygit binary"
  exit 1
}

# Install it to /usr/local/bin
print_msg "Installing binary to '/usr/local/bin/'"
sudo install lazygit -D -t /usr/local/bin/ || {
  print_error "Failed to install lazygit binary"
  exit 1
}

# Clean up
print_msg "Cleaning up"
rm -f lazygit.tar.gz lazygit || {
  print_error "Cleanup failed"
  exit 1
}

print_msg "Lazygit $LAZYGIT_VERSION installed successfully!"
