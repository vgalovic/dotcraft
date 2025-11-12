#!/bin/bash

set -e

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Globals
TMP_DIR=""
LATEST_VERSION=""
INSTALLED_VERSION=""
NVIM_TARBALL=""

get_arch() {
  local arch
  arch=$(uname -m)
  case "$arch" in
    x86_64) NVIM_TARBALL="nvim-linux-x86_64.tar.gz" ;;
    aarch64|arm64) NVIM_TARBALL="nvim-linux-arm64.tar.gz" ;;
    *)
      print_error "Unsupported architecture: $arch"
      exit 1
      ;;
  esac
}


check_and_install_jq() {
  if ! command -v jq >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update -qq
      sudo apt-get install -y -qq jq
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y -q jq
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -Sy --noconfirm jq >/dev/null 2>&1
    else
      echo "Error: No supported package manager found (apt, dnf, pacman). Please install jq manually." >&2
      exit 1
    fi

    # Verify installation silently
    if ! command -v jq >/dev/null 2>&1; then
      echo "Error: jq installation failed. Please install jq manually." >&2
      exit 1
    fi
  fi
}

fetch_latest_stable_version() {
  print_msg "Fetching latest Neovim stable release version from GitHub..."
  LATEST_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases \
      | jq -r '[.[] | select(.prerelease == false and .draft == false)][0].tag_name' \
    | sed 's/^v//')

  if [[ -z "$LATEST_VERSION" ]]; then
    print_error "Failed to fetch latest stable Neovim version."
    exit 1
  fi
  print_msg "Latest stable Neovim version: v$LATEST_VERSION"
}

check_existing_neovim() {
  local nvim_path
  nvim_path=$(command -v nvim || true)

  if [[ -n "$nvim_path" ]]; then
    print_msg "Neovim found at $nvim_path"
    INSTALLED_VERSION=$(nvim --version | head -n 1 | sed -E 's/^NVIM v?([^ ]+).*/\1/')
    print_msg "Installed Neovim version: v$INSTALLED_VERSION"
    return 0
  else
    print_msg "No existing Neovim installation found."
    return 1
  fi
}

should_skip_installation() {
  if [[ "$INSTALLED_VERSION" =~ (dev|nightly|alpha|beta|rc) ]]; then
    print_msg "Installed version is a development or prerelease version. Proceeding with stable installation."
    return 1
  fi

  local installed_stable="${INSTALLED_VERSION%%-*}"

  if dpkg --compare-versions "$installed_stable" ge "$LATEST_VERSION"; then
    print_msg "Installed version (v$installed_stable) is up-to-date or newer than v$LATEST_VERSION. Skipping installation."
    return 0
  fi

  return 1
}

remove_existing_neovim() {
  local nvim_path
  nvim_path=$(command -v nvim || true)

  if [[ -z "$nvim_path" ]]; then
    print_msg "No existing Neovim binary found, no removal needed."
    return
  fi

  if dpkg -S "$nvim_path" &>/dev/null; then
    print_msg "Neovim installed via APT. Removing with apt..."
    sudo apt remove -y neovim
  elif [[ "$nvim_path" == "/usr/local/bin/nvim" ]]; then
    print_msg "Neovim installed from source at /usr/local/bin/nvim. Removing binary..."
    sudo rm -f /usr/local/bin/nvim
  else
    print_msg "Neovim installed at $nvim_path but unknown method. Skipping removal."
  fi
}

download_neovim_tarball() {
  print_msg "Downloading Neovim v$LATEST_VERSION Linux tarball..."

  TMP_DIR=$(mktemp -d)
  cd "$TMP_DIR"

  local download_url="https://github.com/neovim/neovim/releases/download/v${LATEST_VERSION}/${NVIM_TARBALL}"
  print_msg "Downloading from $download_url"

  if ! curl -LO "$download_url"; then
    print_error "Failed to download Neovim v$LATEST_VERSION tarball."
    exit 1
  fi
}

install_neovim() {
  print_msg "Extracting Neovim..."
  tar xzf "$NVIM_TARBALL"

  local extracted_dir="${NVIM_TARBALL%.tar.gz}"

  print_msg "Installing Neovim from $extracted_dir to /usr/local..."
  sudo cp -r "$extracted_dir"/* /usr/local/
}

cleanup() {
  print_msg "Cleaning up temporary files..."
  cd ~
  rm -rf "$TMP_DIR"
}


check_and_install_jq
fetch_latest_stable_version

if check_existing_neovim && should_skip_installation; then
  exit 0
fi

get_arch

remove_existing_neovim
download_neovim_tarball
install_neovim
cleanup

print_msg "Neovim v$LATEST_VERSION installed successfully to /usr/local/bin/nvim"
nvim --version

