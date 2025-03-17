#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_steam() {
    if prompt_yes_default "Do you want to install Steam?"; then
        print_msg "Installing Steam..."
        if command -v apt &> /dev/null; then
            sudo apt install -y steam || { print_error "Failed to install Steam."; return 1; }
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y steam || { print_error "Failed to install Steam."; return 1; }
        else
            print_error "Unsupported package manager. Install Steam manually."
            return 1
        fi
        print_msg "Steam installed."
    else
        print_msg "Skipping Steam installation."
    fi
}

install_heroic_launcher() {
    if prompt_yes_default "Do you want to install Heroic Launcher?"; then
        print_msg "Installing Heroic Launcher..."
        if command -v dnf &> /dev/null; then
            sudo dnf copr enable atim/heroic-games-launcher ||{  print_error "Failed to enable Copr repository."; return 1; }
            sudo dnf install -y heroic-games-launcher-bin ||{  print_error "Failed to install Flatpak."; return 1; }
        elif command -v flatpak &> /dev/null; then
            flatpak install -y flathub com.heroicgameslauncher.hgl || print_error "Failed to install Heroic Games Launcher."
        else
            print_error "Unsupported package manager. Install Heroic Launcher manually."
            return 1
        fi
        print_msg "Heroic Launcher installed."
    else
        print_msg "Skipping Heroic Launcher installation."
    fi
}

install_space_cadet_pinball() {
    # Check for Flatpak availability
    if command -v flatpak &> /dev/null; then
        if prompt_yes_default "Do you want to install Space Cadet Pinball?"; then
            print_msg "Installing Space Cadet Pinball..."
            flatpak install -y flathub com.github.k4zmu2a.spacecadetpinball || print_error "Failed to install Space Cadet Pinball."
            print_msg "Space Cadet Pinball installed."
        else
            print_msg "Skipping Space Cadet Pinball installation."
        fi
    else
        print_msg "Flatpak is not installed. Skipping Space Cadet Pinball installation."
    fi
}

install_steam
install_heroic_launcher
install_space_cadet_pinball

# Run script to install Minecraft
execute_script "setup_minecraft"

print_msg "Games installation completed!"

