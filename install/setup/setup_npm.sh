#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_npm() {
  print_msg "Installing npm..."

  if ! command -v npm &> /dev/null; then
    if command -v apt &> /dev/null; then
      sudo apt install -y nodejs npm || {
        print_error "Failed to install npm using apt."
        exit 1
      }
    elif command -v dnf &> /dev/null; then
      sudo dnf install -y nodejs npm || {
        print_error "Failed to install npm using dnf."
        exit 1
      }
    else
      print_error "Unsupported package manager. Please install npm manually."
      exit 1
    fi

    print_msg "npm installed successfully."
  else
    print_msg "npm is already installed."
  fi
}

install_mermaid() {
  print_msg "Installing mermaid..."
  npm install -g @mermaid-js/mermaid-cli|| {
    print_error "Failed to install mermaid."
    exit 1
  }
  print_msg "mermaid installed successfully."
}

install_npm

if prompt_yes_default "Do you want to install mermaid?"; then
  install_mermaid
fi
