#!/bin/bash

source $HOME/.dotfiles/install/setup/print_and_log.sh

if command -v apt &> /dev/null; then
    # Update the system
    print_msg "Updating the system..."
    sudo apt update -y && sudo apt upgrade -y

    # Install required dependencies
    print_msg "Installing required dependencies..."
    sudo apt install -y dkms build-essential libglvnd-dev acpid

    # Add the NVIDIA PPA
    print_msg "Adding the NVIDIA PPA..."
    sudo add-apt-repository ppa:graphics-drivers/ppa -y
    sudo apt update -y

    # Install the NVIDIA 470.xx drivers
    print_msg "Installing NVIDIA 470.xx drivers..."
    sudo apt install -y nvidia-driver-470

    # Rebuild the initramfs to ensure the driver is loaded properly
    print_msg "Rebuilding initramfs..."
    sudo update-initramfs -u

    print_msg "NVIDIA drivers installation complete! It is recommended to reboot the system."

elif command -v dnf &> /dev/null; then
    # Update the system
    print_msg "Updating the system..."
    sudo dnf update -y

    # Install required dependencies
    print_msg "Installing required dependencies..."
    sudo dnf install -y dkms kernel-devel gcc make acpid

    # Enable RPM Fusion repository for NVIDIA drivers
    print_msg "Enabling RPM Fusion repository..."
    sudo dnf install -y \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    # Install the NVIDIA 470.xx drivers from RPM Fusion (legacy support)
    print_msg "Installing NVIDIA 470.xx drivers..."
    sudo dnf install -y xorg-x11-drv-nvidia-470xx akmod-nvidia-470xx

    # Rebuild the initramfs to ensure the driver is loaded properly
    print_msg "Rebuilding initramfs..."
    sudo dracut --force

    print_msg "NVIDIA drivers installation complete! It is recommended to reboot the system."
fi

