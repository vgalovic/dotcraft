#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

dependencies() {
  print_msg "Checking dependencies..."

  # Detect package manager
  if command -v apt &> /dev/null; then
    PKG_INSTALL="sudo apt install -y"
  elif command -v dnf &> /dev/null; then
    PKG_INSTALL="sudo dnf install -y"
  else
    print_error "Unsupported package manager. Install dependencies manually."
    exit 1
  fi

  # Install git if not installed
  if ! command -v git &> /dev/null; then
    print_msg "git is required. Installing git..."
    $PKG_INSTALL git || { print_error "Failed to install git."; exit 1; }
    print_msg "git installation completed!"
  fi

  # Install make if not installed
  if ! command -v make &> /dev/null; then
    print_msg "make is required. Installing make..."
    $PKG_INSTALL make || { print_error "Failed to install make."; exit 1; }
    print_msg "make installation completed!"
  fi
}

install_colorscript() {
  dependencies

  # Clone colorscript repository
  print_msg "Cloning colorscript repository..."
  git clone https://gitlab.com/dwt1/shell-color-scripts.git || { print_error "Failed to clone colorscript repository."; exit 1; }
  print_msg "Colorscript repository cloned!"

  cd shell-color-scripts || { print_error "Failed to enter shell-color-scripts directory."; exit 1; }

  # Install colorscript
  print_msg "Installing colorscript..."
  sudo make install || { print_error "Failed to install colorscript."; exit 1; }
  print_msg "Colorscript installation completed!"

  # Add completions for Zsh if installed
  if command -v zsh &> /dev/null; then
    print_msg "Adding colorscript completions for zsh..."
    sudo cp completions/_colorscript /usr/share/zsh/site-functions || print_error "Failed to add colorscript completions for zsh."
    print_msg "Colorscript completions for zsh added!"
  fi

  cd .. && rm -rf shell-color-scripts
}

install_colorscript
