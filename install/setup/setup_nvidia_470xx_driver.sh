#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

if command -v apt &> /dev/null; then
  print_msg "Detected APT-based system (Debian/Ubuntu)."

  print_msg "Updating the system..."
  sudo apt update -y && sudo apt upgrade -y

  print_msg "Installing required dependencies..."
  sudo apt install -y dkms build-essential libglvnd-dev acpid

  print_msg "Adding the NVIDIA PPA..."
  sudo add-apt-repository ppa:graphics-drivers/ppa -y
  sudo apt update -y

  print_msg "Installing NVIDIA 470.xx drivers..."
  sudo apt install -y nvidia-driver-470

  print_msg "Rebuilding initramfs..."
  sudo update-initramfs -u

  print_msg "NVIDIA drivers installation complete! Please reboot."

elif command -v dnf &> /dev/null; then
  print_msg "Detected DNF-based system (Fedora/RHEL)."

  print_msg "Updating the system..."
  sudo dnf update -y

  print_msg "Installing required dependencies..."
  sudo dnf install -y dkms kernel-devel gcc make acpid

  print_msg "Enabling RPM Fusion repository..."
  sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  print_msg "Installing NVIDIA 470.xx drivers..."
  sudo dnf install -y xorg-x11-drv-nvidia-470xx akmod-nvidia-470xx

  print_msg "Rebuilding initramfs..."
  sudo dracut --force

  print_msg "NVIDIA drivers installation complete! Please reboot."

elif command -v pacman &> /dev/null; then
  print_msg "Detected Pacman-based system (Arch/Manjaro)."

  if ! command -v yay &> /dev/null; then
    print_msg "yay is not installed. Installing yay..."
    must_execute_script "setup_yay" || {
      print_msg "Error: 'yay' installation script failed."
      exit 1
    }
  fi

  print_msg "Installing kernel headers..."
  sudo pacman -S --needed linux-headers

  print_msg "Installing NVIDIA 470.xx legacy drivers..."
  yay -S --noconfirm nvidia-470xx-dkms

  print_msg "NVIDIA 470.xx drivers installed. Please reboot your system."

else
  print_msg "Unsupported or unknown package manager. Exiting."
  exit 1
fi
