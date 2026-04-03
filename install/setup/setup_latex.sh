#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_latex() {
  print_msg "Installing LaTeX packages..."

  if command -v apt-get > /dev/null; then
    sudo apt-get install -y texlive-latex-base || {
      print_error "Failed to install TexLive base"
      exit 1
    }

    sudo apt-get install -y texlive-fonts-recommended || print_error "Failed to install recommended fonts"
    sudo apt-get install -y texlive-fonts-extra || print_error "Failed to install extra fonts"

    sudo apt-get install -y texlive-latex-extra || print_error "Failed to install extra packages"
    sudo apt-get install -y texlive-science || print_error "Failed to install science packages"

  elif command -v dnf > /dev/null; then
    sudo dnf install -y texlive-scheme-medium || {
      print_error "Failed to install TexLive base"
      exit 1
    }

    sudo dnf install -y texlive-polyglossia texlive-cm-unicode || print_error "Failed to install Polyglossia support"

    sudo dnf install -y texlive-babel-serbian || print_error "Failed to install serbian language support"

  else
    print_error "Unsupported package manager. Please install LaTeX manually."
    exit 1
  fi

  print_msg "LaTeX installation completed."
}

install_latex
