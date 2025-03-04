#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_latex() {
    print_msg "Installing  TexLive base..."
    sudo apt-get install texlive-latex-base || {
        print_error "Failed to install TexLive base"
        exit 1
    }

    print_msg "Installing recommended and extra fonts..."
    sudo apt-get install texlive-fonts-recommended || print_error "Failed to install recommended fonts"
    sudo apt-get install texlive-fonts-extra || print_error "Failed to install extra fonts"

    print_msg "Installing extra packages..."
    sudo apt-get install texlive-latex-extra || print_error "Failed to install extra packages"
    sudo apt-get install texlive-science || print_error "Failed to install science packages"
}

install_latex
