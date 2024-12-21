#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_minecraft() {
    # Download the Minecraft launcher
    print_msg "Downloading Minecraft launcher..."
    wget -O minecraft-launcher.deb https://launcher.mojang.com/download/Minecraft.deb || print_error "Failed to download Minecraft launcher."

    # Install the Minecraft launcher
    print_msg "Installing Minecraft launcher..."
    sudo dpkg -i minecraft-launcher.deb || print_error "Failed to install Minecraft launcher."

    # Fix any dependency issues that may arise
    print_msg "Fixing any dependency issues..."
    sudo apt-get install -f || print_error "Failed to fix dependencies."

    # Clean up the downloaded package
    print_msg "Cleaning up..."
    rm minecraft-launcher.deb || print_error "Failed to remove the downloaded package."

    print_msg "Minecraft installation completed! You can start it from your applications menu."

    # Check for Flatpak and install Heroic Games Launcher if available
    if command -v flatpak &> /dev/null; then
        print_msg "Installing Coubiomes Viewer..."
        flatpak install -y flathub com.github.cubitect.cubiomes-viewer || print_error "Failed to install Coubiomes Viewer."
        print_msg "Coubiomes Viewer installed."
    else
        print_msg "Flatpak is not installed. Skipping Coubiomes Viewer installation."
    fi

}

install_games() {
    if prompt_yes_default "Do you want to install Steam?"; then
        print_msg "Installing Steam..."
        sudo apt install -y steam || print_error "Failed to install Steam."
        print_msg "Steam installed."
    else
        print_msg "Skipping Steam installation."
    fi

    # Check for Flatpak and install Heroic Games Launcher if available
    if command -v flatpak &> /dev/null; then
        if prompt_yes_default "Do you want to install Heroic Launcher?"; then
            print_msg "Installing Heroic Launcher..."
            flatpak install -y flathub com.heroicgameslauncher.hgl || print_error "Failed to install Heroic Games Launcher."
            print_msg "Heroic Launcher installed."
        else
            print_msg "Skipping Heroic Launcher installation."
        fi

        if prompt_yes_defualt "Do you wnat to install Space Cadet Pinball?"; then
            print_msg "Installing Space Cadet Pinball..."
            flatpak install -y flathub com.github.k4zmu2a.spacecadetpinball || print_error "Failed to install Space Cadet Pinball."
            print_msg "Space Cadet Pinball installed."
        else
            print_msg "Skipping Space Cadet Pinball installation."
        fi
    fi

    # Check if Minecraft is already installed; if not, install it
    if prompt_yes_default "Do you want to install Minecraft?"; then
        install_minecraft
    else
        print_msg "Skipping Minecraft installation."
    fi

}

install_games
