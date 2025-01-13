#!/bin/bash

print_msg() {
    echo -e "\e[1;32m$1\e[0m"
}

if command -v apt &> /dev/null
then
    print_msg "Updating apt..."
    sudo apt update
    sudo apt upgrade -y
    print_msg "apt-get updated."
fi

if command -v flatpak &> /dev/null
then
    print_msg "Updating flatpak..."
    flatpak update
    print_msg "flatpak updated."
fi

if command -v snap &> /dev/null
then
    print_msg "Updating snap..."
    snap refresh
    print_msg "snap updated."
fi

if command -v brew &> /dev/null
then
    print_msg "Updating brew..."
    brew update
    brew upgrade
    print_msg "brew updated."
fi

print_msg "All updates done."





