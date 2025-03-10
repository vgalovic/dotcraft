#!/bin/bash

source ~/.dotfiles/install/setup/print_and_log.sh

install_ntfs() {
    print_msg "Installing NTFS drivers"
    sudo apt-get install -y ntfs-3g || print_error "Failed to install NTFS drivers"
    print_msg "Installed NTFS drivers"
}

install_fonts() {
    print_msg "Installing Microsoft fonts"
    sudo apt install ttf-mscorefonts-installer -y || print_error "Failed to install Microsoft fonts"
    print_msg "Installed Microsoft fonts"
}

install_ntfs
install_fonts
