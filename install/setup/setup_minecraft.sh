#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_debian_minecraft() {
  # Ensure wget is installed
  if ! command -v wget &> /dev/null; then
    print_msg "wget not found, installing wget..."
    sudo apt install -y wget || { print_error "Failed to install wget."; return 1; }
    print_msg "wget installed."
  fi

  # Download the Minecraft launcher
  print_msg "Downloading Minecraft launcher..."
  wget -O minecraft-launcher.deb https://launcher.mojang.com/download/Minecraft.deb || {
    print_error "Failed to download Minecraft launcher."
    return 1
  }

  # Install the Minecraft launcher
  print_msg "Installing Minecraft launcher..."
  sudo dpkg -i minecraft-launcher.deb || {
    print_error "Failed to install Minecraft launcher."
    return 1
  }

  # Fix any dependency issues that may arise
  print_msg "Fixing any dependency issues..."
  sudo apt-get install -f || { print_error "Failed to fix dependencies."; return 1; }

  # Clean up the downloaded package
  print_msg "Cleaning up..."
  rm minecraft-launcher.deb || print_error "Failed to remove the downloaded package."
}

install_arch_minecraft() {
  # Ensure yay is available
  if ! command -v yay &> /dev/null; then
    print_msg "yay not found, installing yay..."
    must_execute_script "setup_yay" || { print_error "Failed to install yay."; return 1; }
  fi

  # Install Minecraft launcher from AUR using yay
  print_msg "Installing Minecraft launcher from AUR using yay..."
  sudo yay -S minecraft-launcher --noconfirm || {
    print_error "Failed to install Minecraft launcher."
    return 1
  }
}

install_other_minecraft() {
  MINECRAFT_URL="https://launcher.mojang.com/download/Minecraft.tar.gz"
  ICON_URL="https://www.minecraft.net/etc.clientlibs/minecraft/clientlibs/main/resources/img/Launcher_Icon.png"
  INSTALL_DIR="/usr/local/bin"
  TEMP_DIR="/tmp/minecraft"
  DESKTOP_FILE="/usr/share/applications/minecraft.desktop"
  ICON_PATH="/usr/share/pixmaps/minecraft-launcher.png"

  # Detect package manager
  if command -v dnf &> /dev/null; then
    PKG_INSTALL="sudo dnf install -y"
  elif command -v zypper &> /dev/null; then
    PKG_INSTALL="sudo zypper install -y"
  else
    print_error "Unsupported package manager. Install dependencies manually."
    return 1
  fi

  # Ensure wget and tar are available
  if ! command -v wget &> /dev/null; then
    print_msg "wget is required. Installing wget..."
    $PKG_INSTALL wget || { print_error "Failed to install wget."; return 1; }
    print_msg "wget installation completed!"
  fi

  if ! command -v tar &> /dev/null; then
    print_msg "tar is required. Installing tar..."
    $PKG_INSTALL tar || { print_error "Failed to install tar."; return 1; }
    print_msg "tar installation completed!"
  fi

  # Create temporary directory
  mkdir -p "$TEMP_DIR"
  cd "$TEMP_DIR" || return 1

  # Download Minecraft
  print_msg "Downloading Minecraft..."
  wget -O Minecraft.tar.gz "$MINECRAFT_URL" || { print_error "Failed to download Minecraft." >&2; return 1; }

  # Extract files
  print_msg "Extracting Minecraft..."
  tar -xzf Minecraft.tar.gz || { print_error "Failed to extract Minecraft." >&2; return 1; }

  # Navigate to extracted directory
  cd minecraft-launcher* || { print_error "Minecraft launcher directory not found."; return 1; }

  # Find the launcher binary (adjust as needed)
  if [ -f "minecraft-launcher" ]; then
    sudo cp minecraft-launcher "$INSTALL_DIR/minecraft" || { print_error "Failed to install Minecraft."; return 1; }
    sudo chmod +x "$INSTALL_DIR/minecraft"
  else
    print_error "Minecraft launcher binary not found."
    return 1
  fi

  # Download the Minecraft icon
  print_msg "Downloading Minecraft icon..."
  sudo curl -o "$ICON_PATH" -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36" \
    "https://www.minecraft.net/etc.clientlibs/minecraft/clientlibs/main/resources/img/Launcher_Icon.png" || {
    print_error "Failed to download Minecraft icon. Using fallback icon."
    return 1
  }

  # Create .desktop file for launcher
  print_msg "Creating .desktop file for launcher..."
  echo "[Desktop Entry]
Version=1.0
Name=Minecraft
Comment=Minecraft Launcher
Exec=$INSTALL_DIR/minecraft
Icon=$ICON_PATH
Terminal=false
Type=Application
    Categories=Game;" | sudo tee "$DESKTOP_FILE" > /dev/null

  sudo chmod +x "$DESKTOP_FILE"

  # Cleanup
  rm -rf "$TEMP_DIR"
}

install_flatpak_cubiomes() {
  # Check for Flatpak and install Cubiomes Viewer if available
  if command -v flatpak &> /dev/null; then
    print_msg "Flatpak detected, installing Cubiomes Viewer..."
    flatpak install -y flathub com.github.cubitect.cubiomes-viewer || print_error "Failed to install Cubiomes Viewer via Flatpak."
    print_msg "Cubiomes Viewer installation completed!"
  else
    print_msg "Flatpak is not installed. Skipping Cubiomes Viewer installation."
  fi
}

install_minecraft() {
  if command -v apt &> /dev/null; then
    print_msg "Debian-based distribution detected, installing Minecraft..."
    install_debian_minecraft
  elif command -v pacman &> /dev/null; then
    print_msg "Arch-based distribution detected, installing Minecraft..."
    install_arch_minecraft
  else
    print_msg "Unsupported distribution detected, installing Minecraft from binary..."
    install_other_minecraft
  fi

  print_msg "Minecraft installed successfully! You can launch it from your application menu."
}

install_minecraft
install_flatpak_cubiomes
