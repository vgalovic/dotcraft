#!/bin/bash

# Update package database
sudo pacman -Syu --noconfirm

# Install base-devel if not already installed
if ! pacman -Q base-devel > /dev/null 2>&1; then
    echo "Installing base-devel..."
    sudo pacman -S --noconfirm base-devel
fi

# Install yay dependencies
if ! pacman -Q git > /dev/null 2>&1; then
    echo "Installing git..."
    sudo pacman -S --noconfirm git
fi

# Navigate to /tmp directory
cd /tmp

# Clone the yay repository from AUR
echo "Cloning yay from AUR into /tmp..."
git clone https://aur.archlinux.org/yay.git

# Navigate into the yay directory
cd yay

# Build and install yay
echo "Building and installing yay..."
makepkg -si --noconfirm

# Clean up by removing the yay directory
cd ..
rm -rf yay

echo "yay has been installed successfully!"
