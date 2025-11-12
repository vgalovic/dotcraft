#!/bin/bash

# This script installs MEGA Sync and its file manager integrations
# It detects the OS and downloads the appropriate package for that OS.

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

os=""
os_version=""

# Set the download path to the current user's Downloads directory
download_path="/tmp"

cleanup() {
  echo "Performing cleanup..."
  rm -f -- "$download_path"/*-megasync-*
}
trap cleanup EXIT

which_os() {
  source /etc/os-release
  case "$ID" in
    arch)
      os="arch"
      ;;
    debian)
      os="debian"
      ;;
    fedora)
      os="fedora"
      ;;
    linuxmint)
      os="linuxmint"
      ;;
    opensuse*)
      os="opensuse"
      ;;
    ubuntu)
      os="ubuntu"
      ;;
    raspbian)
      os="raspbian"
      ;;
    *)
      print_error "Unsupported OS detected ($ID). Exiting."
      exit 1
      ;;
  esac
}

# For Linux Mint, compute corresponding Ubuntu version (used by MEGA repos)
get_mint_version() {
  # Extract the major version number
  if [[ $os_version =~ ^([0-9]+) ]]; then
    major_version="${BASH_REMATCH[1]}"

    # Check if the version is odd or even and map to Ubuntu LTS
    if ((major_version % 2 == 0)); then
      ubuntu_version=$((major_version + 2)).04
    else
      ubuntu_version=$((major_version + 1)).04
    fi

    # Log the message without echoing it
    print_msg "Detected Linux Mint version $os_version, corresponding to Ubuntu $ubuntu_version." >&2
    # Then echo the Ubuntu version to be used later
    os_version="$ubuntu_version"
  else
    print_error "Unsupported Linux Mint version: $os_version." >&2
    return 1
  fi
}

# Read VERSION_ID from /etc/os-release and sanitize it
get_os_version() {
  if [ -f /etc/os-release ]; then
    os_version=$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

    if [[ -n "$os_version" ]]; then
      # Remove any trailing periods or extra characters that might appear
      os_version=$(echo "$os_version" | sed 's/\.$//')
    else
      print_error "Failed to detect OS version from /etc/os-release."
      return 1
    fi
  else
    print_error "The '/etc/os-release' file is not available. Please check your system."
    return 1
  fi
}

# Function to detect all installed file managers
detect_file_managers() {
  local managers=()
  # Check common file managers and add found ones to the list
  for fm in nautilus nemo dolphin thunar; do
    if command -v "$fm" &>/dev/null; then
      managers+=("$fm")
    fi
  done

  echo "${managers[@]}"
}

# Download MEGA Sync for the detected OS and version
download_megasync() {
  local megasync_pkg
  local megasync_path

  case "$os" in
    arch)
      if pacman -Q megasync &>/dev/null; then
        print_msg "MEGA sync is already installed. Skipping installation."
        return 0
      fi

      megasync_pkg="Arch_Extra/x86_64/megasync-x86_64.pkg.tar.zst"
      megasync_path="$download_path/megasync.pkg.tar.zst"
      ;;
    debian)
      if dpkg -l | grep -q megasync; then
        print_msg "MEGA sync is already installed. Skipping installation."
        return 0
      fi

      megasync_pkg="Debian_${os_version}/amd64/megasync-Debian_${os_version}_amd64.deb"
      megasync_path="$download_path/megasync.deb"
      ;;
    fedora)
      if rpm -q megasync &>/dev/null; then
        print_msg "MEGA sync is already installed. Skipping installation."
        return 0
      fi

      megasync_pkg="Fedora_${os_version}/x86_64/megasync-Fedora_${os_version}.x86_64.rpm"
      megasync_path="$download_path/megasync.rpm"
      ;;
    linuxmint | ubuntu)
      if dpkg -l | grep -q megasync; then
        print_msg "MEGA sync is already installed. Skipping installation."
        return 0
      fi

      megasync_pkg="xUbuntu_${os_version}/amd64/megasync-xUbuntu_${os_version}_amd64.deb"
      megasync_path="$download_path/megasync.deb"
      ;;
    opensuse)
      if zypper -q info megasync &>/dev/null; then
        print_msg "MEGA sync is already installed. Skipping installation."
        return 0
      fi

      if [ "$os_version" == "Tumbleweed" ]; then
        megasync_pkg="openSUSE_Tumbleweed/x86_64/megasync-openSUSE_Tumbleweed.x86_64.rpm"
      else
        megasync_pkg="openSUSE_Leap_${os_version}/x86_64/megasync-openSUSE_Leap_${os_version}.x86_64.rpm"
      fi
      megasync_path="$download_path/megasync.rpm"
      ;;
    raspbian)
      if dpkg -l | grep -q megasync; then
        print_msg "MEGA sync is already installed. Skipping installation."
        return 0
      fi

      megasync_pkg="Raspbian_${os_version}/armhf/megasync-Raspbian_${os_version}_armhf.deb"
      megasync_path="$download_path/megasync.deb"
      ;;
    *)
      print_error "Unsupported OS: $os. Exiting."
      exit 1
      ;;
  esac

  print_msg "Downloading MEGA Sync package for $os..."
  wget -c "https://mega.nz/linux/repo/$megasync_pkg" -O "$megasync_path" || {
    print_error "Failed to download MEGA Sync package."
    return 1
  }

  chmod 644 "$megasync_path" || {
    print_error "Failed to change permissions of the downloaded file."
    return 1
  }

  install_megasync "$megasync_path"
}

# Install the downloaded MEGA Sync package
install_megasync() {
  local megasync_path="$1"

  local success="MEGA Sync is installed."
  local failure="Failed to install MEGA Sync."

  print_msg "Installing MEGA Sync on $os..."
  case "$os" in
    arch)
      sudo pacman -U "$megasync_path" && print_msg "$success" || print_error "$failure"
      ;;
    linuxmint | ubuntu | debian | raspbian)
      sudo apt install -y "$megasync_path" && print_msg "$success" || print_error "$failure"
      ;;
    fedora)
      sudo dnf install -y "$megasync_path" && print_msg "$success" || print_error "$failure"
      ;;
    opensuse)
      sudo zypper in -y "$megasync_path" && print_msg "$success" || print_error "$failure"
      ;;
    *)
      print_error "Unsupported OS. Exiting."
      exit 1
      ;;
  esac

  print_msg "Removing the MEGA Sync package..."
  rm "$megasync_path" || print_error "Failed to remove MEGA Sync package."
}

# Function to download and install file manager integration for MEGA Sync
download_file_manager_integration() {
  local file_manager="$1"
  local file_manager_integration_pkg
  local file_manager_integration_path

  case "$os" in
    arch)
      if pacman -Q "${file_manager}-megasync" &>/dev/null; then
        print_msg "${file_manager}-megasync is already installed. Skipping installation."
        return 0
      fi

      file_manager_integration_pkg="Arch_Extra/x86_64/${file_manager}-megasync-x86_64.pkg.tar.zst"
      file_manager_integration_path="$download_path/${file_manager}-megasync.pkg.tar.zst"
      ;;
    debian)
      if dpkg -l | grep -q "${file_manager}-megasync"; then
        print_msg "${file_manager}-megasync is already installed. Skipping installation."
        return 0
      fi

      file_manager_integration_pkg="Debian_${os_version}/amd64/${file_manager}-megasync-Debian_${os_version}_amd64.deb"
      file_manager_integration_path="$download_path/${file_manager}-megasync.deb"
      ;;
    fedora)
      if rpm -q "${file_manager}-megasync" &>/dev/null; then
        print_msg "${file_manager}-megasync is already installed. Skipping installation."
        return 0
      fi

      file_manager_integration_pkg="Fedora_${os_version}/x86_64/${file_manager}-megasync-Fedora_${os_version}.x86_64.rpm"
      file_manager_integration_path="$download_path/${file_manager}-megasync.rpm"
      ;;
    linuxmint | ubuntu)
      if dpkg -l | grep -q "${file_manager}-megasync"; then
        print_msg "${file_manager}-megasync is already installed. Skipping installation."
        return 0
      fi

      file_manager_integration_pkg="xUbuntu_${os_version}/amd64/${file_manager}-megasync-xUbuntu_${os_version}_amd64.deb"
      file_manager_integration_path="$download_path/${file_manager}-megasync.deb"
      ;;
    opensuse)
      if zypper -q info "${file_manager}-megasync" &>/dev/null; then
        print_msg "${file_manager}-megasync is already installed. Skipping installation."
        return 0
      fi

      if [ "$os_version" == "Tumbleweed" ]; then
        file_manager_integration_pkg="openSUSE_Tumbleweed/x86_64/${file_manager}-megasync-openSUSE_Tumbleweed.x86_64.rpm"
      else
        file_manager_integration_pkg="openSUSE_Leap_${os_version}/x86_64/${file_manager}-megasync-openSUSE_Leap_${os_version}.x86_64.rpm"
      fi
      file_manager_integration_path="$download_path/${file_manager}-megasync.rpm"
      ;;
    raspbian)
      print_msg "Raspbian is not supported for file manager integrations."
      return 0
      ;;
    *)
      print_error "Unsupported OS. Exiting."
      exit 1
      ;;
  esac

  print_msg "Downloading MEGA file manager integration for $file_manager..."
  wget -c "https://mega.nz/linux/repo/$file_manager_integration_pkg" -O "$file_manager_integration_path" || {
    print_error "Failed to download MEGA file manager integration for $file_manager."
    return 1
  }

  print_msg "Changing permissions of the downloaded file..."
  chmod 644 "$file_manager_integration_path" || {
    print_error "Failed to change permissions of the downloaded file."
    return 1
  }

  install_file_manager_integration "$file_manager" "$file_manager_integration_path"
}

install_file_manager_integration() {
  local file_manager="$1"
  local file_manager_integration_path="$2"

  case "$os" in
    linuxmint | ubuntu | debian)
      if sudo apt install -y "$file_manager_integration_path"; then
        print_msg "${file_manager}'s megasync integration installed."
      else
        print_error "Failed to install ${file_manager}'s megasync integration."
      fi
      ;;
    fedora)
      if sudo dnf install -y "$file_manager_integration_path"; then
        print_msg "${file_manager}'s megasync integration installed."
      else
        print_error "Failed to install ${file_manager}'s megasync integration."
      fi
      ;;
    opensuse)
      if sudo zypper in -y "$file_manager_integration_path"; then
        print_msg "${file_manager}'s megasync integration installed."
      else
        print_error "Failed to install ${file_manager}'s megasync integration."
      fi
      ;;
    *)
      print_error "Unsupported OS. Exiting."
      exit 1
      ;;
  esac

  print_msg "Removing the MEGA file manager integration package..."
  rm -- "$file_manager_integration_path" || print_error "Failed to remove MEGA file manager integration package."
}

# Function to handle installation for all supported file managers
find_file_managers() {
  local file_managers

  file_managers=$(detect_file_managers)

  if [[ -z "$file_managers" ]]; then
    print_msg "No supported file managers found. Skipping integration installation."
    return
  fi

  for file_manager in $file_managers; do
    print_msg "Installing integration for $file_manager..."
    download_file_manager_integration "$file_manager" || {
      print_error "Failed to install integration for $file_manager."
    }
  done
}

# Detect OS and adjust logic for special cases
which_os
print_msg "Detected OS: $os"

case "$os" in
  arch)
    # Arch-specific logic is handled in functions
    ;;
  linuxmint)
    # For Mint, map to corresponding Ubuntu version used by MEGA repo
    get_os_version
    get_mint_version
    ;;
  opensuse)
    # Distinguish between Tumbleweed and Leap
    if grep -q "Tumbleweed" /etc/os-release; then
      os_version="Tumbleweed"
      print_msg "Detected OS version: $os_version"
    elif grep -q "Leap" /etc/os-release; then
      get_os_version
      print_msg "Detected OS version: Leap $os_version"
    else
      print_error "Unknown openSUSE version"
      exit 1
    fi
    ;;
  *)
    # Default path: read VERSION_ID and proceed
    get_os_version
    print_msg "Detected OS version: $os_version"
    ;;
esac

# Main actions
download_megasync
find_file_managers
