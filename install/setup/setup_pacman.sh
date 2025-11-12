#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Update system
update_pacman() {
  print_msg "Updating system packages..."
  sudo pacman -Syu --noconfirm || { print_error "Failed to update system packages"; exit 1; }
}

# Install clipboard utility depending on display server
detect_compositor() {
  if [ -n "$WAYLAND_DISPLAY" ]; then
    echo "wayland"
  elif [ -n "$DISPLAY" ]; then
    echo "x11"
  else
    echo "unknown"
  fi
}

install_clipboard() {
  compositor=$(detect_compositor)

  case $compositor in
    wayland)
      print_msg "Detected Wayland. Installing wl-clipboard..."
      sudo pacman -S --noconfirm wl-clipboard || print_error "Failed to install wl-clipboard"
      ;;
    x11)
      print_msg "Detected X11. Installing xclip..."
      sudo pacman -S --noconfirm xclip || print_error "Failed to install xclip"
      ;;
    *)
      print_error "Could not detect the compositor. Clipboard utility not installed."
      ;;
  esac
}

install_basic_pacman() {
  local packages=(
    git
    hub
    curl
    wget
  )

  for pkg in "${packages[@]}"; do
    print_msg "Installing: $pkg"
    sudo pacman -S --noconfirm "$pkg" || print_error "Failed to install $pkg"
  done
}

install_developer_apps() {
  local packages=(
    base-devel
    gcc
    clang
    make
    cmake
    systemc
  )

  for pkg in "${packages[@]}"; do
    print_msg "Installing developer tool: $pkg"
    sudo pacman -S --noconfirm "$pkg" || print_error "Failed to install $pkg"
  done
}

install_avr() {
  local packages=(
    avr-gcc
    avr-libc
    avrdude
    simulavr
    gdb-avr
  )

  for pkg in "${packages[@]}"; do
    print_msg "Installing AVR tool: $pkg"
    sudo pacman -S --noconfirm "$pkg" || print_error "Failed to install $pkg"
  done
}

install_github_cli() {
  print_msg "Installing GitHub CLI..."
  sudo pacman -S --noconfirm github-cli || print_error "Failed to install GitHub CLI"
}

install_copyq() {
  print_msg "Installing CopyQ..."
  sudo pacman -S --noconfirm copyq || print_error "Failed to install CopyQ"
}

install_conky() {
  print_msg "Installing Conky..."
  sudo pacman -S --noconfirm conky || print_error "Failed to install Conky"
}

install_mpv() {
  print_msg "Installing MPV..."
  sudo pacman -S --noconfirm mpv || print_error "Failed to install MPV"
}

install_zathura() {
  print_msg "Installing Zathura..."
  sudo pacman -S --noconfirm zathura || print_error "Failed to install Zathura"
}

update_pacman
install_clipboard
install_basic_pacman

if prompt_yes_default "Do you want to install developer applications?"; then
  install_developer_apps
fi

if prompt_yes_default "Do you want to install AVR tools?"; then
  install_avr
fi

if prompt_yes_default "Do you want to install GitHub CLI?"; then
  install_github_cli
fi

if prompt_yes_default "Do you want to install ZSH?"; then
  install_zsh
fi

if [[ "$XDG_CURRENT_DESKTOP" != "KDE" ]]; then
  if prompt_yes_default "Do you want to install CopyQ?"; then
    install_copyq
  fi

  if prompt_yes_default "Do you want to install Conky?"; then
    install_conky
  fi
fi

if prompt_yes_default "Do you want to install MPV?"; then
  install_mpv
fi

if prompt_yes_default "Do you want to install Zathura?"; then
  install_zathura
fi
