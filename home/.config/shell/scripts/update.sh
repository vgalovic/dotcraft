#!/bin/bash

print_msg() {
    echo -e "\e[1;32m$1\e[0m"
}

if command -v apt &> /dev/null; then
    print_msg "Updating apt..."
    sudo apt update
    sudo apt upgrade -y
    print_msg "apt updated."
fi

if command -v dnf &> /dev/null; then
    print_msg "Updating dnf..."
    sudo dnf upgrade -y
    print_msg "dnf updated."
fi

if command -v flatpak &> /dev/null; then
    print_msg "Updating flatpak..."
    flatpak update -y
    print_msg "flatpak updated."
fi

if command -v snap &> /dev/null; then
    print_msg "Updating snap..."
    snap refresh
    print_msg "snap updated."
fi

if command -v brew &> /dev/null; then
    print_msg "Updating brew..."
    brew update
    brew upgrade
    print_msg "brew updated."
fi

if command -v cargo &> /dev/null; then
    print_msg "Updating cargo packages..."
    cargo install-update --all
    print_msg "cargo packages updated."
fi

if command -v pipx &> /dev/null; then
    print_msg "Updating pipx packages..."
    pipx upgrade-all
    print_msg "pipx packages updated."
fi

print_msg "All updates done."
