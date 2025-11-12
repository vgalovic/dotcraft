#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to detect package manager
detect_package_manager() {
  if command -v apt &>/dev/null; then
    echo "apt"
  elif command -v dnf &>/dev/null; then
    echo "dnf"
  elif command -v pacman &>/dev/null; then
    echo "pacman"
  else
    echo "unknown"
  fi
}

PKG_MANAGER=$(detect_package_manager)

# Function to check if a repository exists
repository_exists() {
  if [ "$PKG_MANAGER" = "apt" ]; then
    grep -h "^deb .*papirus/papirus" /etc/apt/sources.list /etc/apt/sources.list.d/* &>/dev/null
  else
    echo "Skipping repository check for non-APT systems."
  fi
}

# Function to add Papirus repository
add_repository() {
  if [ "$PKG_MANAGER" = "apt" ]; then
    if repository_exists; then
      print_msg "Papirus repository already exists."
    else
      print_msg "Adding Papirus repository..."
      sudo add-apt-repository -y ppa:papirus/papirus || { print_error "Failed to add Papirus repository."; exit 1; }
      print_msg "Updating package index..."
      sudo apt update || { print_error "Failed to update package index."; exit 1; }
    fi
  fi
}

# Function to install a package
install_package() {
  local package="$1"
  print_msg "Installing $package..."
  if [ "$PKG_MANAGER" = "apt" ]; then
    sudo apt install -y "$package" || print_error "Failed to install $package."
  elif [ "$PKG_MANAGER" = "dnf" ]; then
    sudo dnf install -y "$package" || print_error "Failed to install $package."
  elif [ "$PKG_MANAGER" = "pacman" ]; then
    sudo pacman -S --noconfirm "$package" || print_error "Failed to install $package."
  else
    print_error "Unsupported package manager. Exiting."
    exit 1
  fi
  print_msg "$package installation completed!"
}

# Function to set Kvantum paths (including QT_STYLE_OVERRIDE)
set_kvantum_paths() {
  print_msg "Setting Kvantum paths..."

  # Only append if not already present
  if ! grep -q "kvantummanager" ~/.profile; then
    echo "# Check for Kvantum and set QT_STYLE_OVERRIDE" >> ~/.profile
    echo "if command -v kvantummanager >/dev/null 2>&1; then" >> ~/.profile
    echo "    export QT_STYLE_OVERRIDE=kvantum" >> ~/.profile
    echo "fi" >> ~/.profile
    print_msg "Kvantum paths added to .profile."
  else
    print_msg "Kvantum paths are already present in .profile."
  fi
}

# Function to install Kvantum
install_kvantum() {
  if [ "$PKG_MANAGER" = "apt" ]; then
    install_package "qt5-style-kvantum"
    install_package "qt6-style-kvantum"
    install_package "qt5-style-kvantum-themes"
  elif [ "$PKG_MANAGER" = "dnf" ]; then
    install_package "kvantum"
    install_package "kvantum-qt5"
    install_package "kvantum-qt6"
  elif [ "$PKG_MANAGER" = "pacman" ]; then
    install_package "kvantum"
  else
    print_error "Unsupported package manager. Exiting."
    exit 1
  fi
  print_msg "Kvantum installation completed!"
}



# Function to install Papirus icon theme and/or Kvantum styles

# Function to install Papirus icon theme and/or Kvantum styles
install_papirus_kvantum() {
  local default_option=4 # Default to "Both"

  echo -e "Choose an installation option:"
  echo -e "\t1) Skip"
  echo -e "\t2) Papirus icon theme"
  echo -e "\t3) Kvantum style manager (Qt)"
  echo -e "\t4) Both\n"

  read -rp "Enter choice [1-4]: " choice

  case "$choice" in
    1)
      print_msg "Skipping installation."
      ;;
    2)
      add_repository
      install_package "papirus-icon-theme"
      ;;
    3)
      add_repository
      install_kvantum
      set_kvantum_paths
      ;;
    4)
      add_repository
      install_package "papirus-icon-theme"
      install_kvantum
      set_kvantum_paths
      ;;
    *)
      print_error "Invalid option. Exiting."
      exit 1
      ;;
  esac
}

# Main script logic
if [[ "$XDG_CURRENT_DESKTOP" != "KDE" ]]; then
  # Call the function only if the desktop is NOT KDE
  install_papirus_kvantum
else
  print_msg "KDE detected. No need to install Kvantum on this system."
  if prompt_yes_default_no "Do you want to install Papirus icon theme?"; then
    add_repository
    install_package "papirus-icon-theme"
  fi
fi
