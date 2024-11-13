#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to install Flatpak and its applications
install_flatpak() {
    # Install Flatpak if not installed
    if ! command -v flatpak &> /dev/null; then
        print_msg "Flatpak is not installed. Installing..."
        sudo apt update && sudo apt install -y flatpak || { print_error "Failed to install Flatpak"; return 1; }
    else
        print_msg "Flatpak is already installed."
    fi

    # Add Flathub repository if not already added
    if ! flatpak remote-list | grep -q "flathub"; then
        print_msg "Adding Flathub repository..."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || { print_error "Failed to add Flathub repository"; return 1; }
    else
        print_msg "Flathub repository is already added."
    fi

    # Install Flatpak integration based on desktop environment
    if [[ "$XDG_CURRENT_DESKTOP" =~ "GNOME" ]]; then
        # Install GNOME Flatpak plugin
        if ! dpkg -l | grep -q gnome-software-plugin-flatpak; then
            print_msg "Installing GNOME Flatpak plugin..."
            sudo apt install -y gnome-software-plugin-flatpak gnome-software || print_error "Failed to install GNOME Flatpak plugin."
        else
            print_msg "GNOME Flatpak plugin is already installed."
        fi
    fi
}

# Function to load Flatpak applications from a file into an array
load_flatpak_applications() {
    APP_DIR="$HOME/.dotfiles/install/app_list"
    local file="$APP_DIR/flatpak_applications.txt"
    flatpak_applications=()

    # Check if the file exists
    if [[ -f "$file" ]]; then
        print_msg "Loading Flatpak applications from $file..."

        # Read each line of the file and add it to the array
        while IFS= read -r app; do
            # Skip empty lines and comments (lines starting with #)
            if [[ -n "$app" && ! "$app" =~ ^# ]]; then
                flatpak_applications+=("$app")
            fi
        done < "$file"

        # Check if any applications were loaded
        if [[ ${#flatpak_applications[@]} -eq 0 ]]; then
            print_warning "No valid applications found in $file."
        else
            print_msg "Applications loaded from $file."
        fi
    else
        print_warning "$file not found. Skipping Flatpak application installation."
    fi
}

# Function to install Flatpak applications
install_flatpak_apps() {
    # Load Flatpak applications
    load_flatpak_applications    

    # Check if any applications are available to install
    if [[ ${#flatpak_applications[@]} -eq 0 ]]; then
        print_warning "No Flatpak applications found to install."
        return 0
    fi

    # Display the applications to be installed
    print_msg "The following Flatpak applications will be installed:"
    for app in "${flatpak_applications[@]}"; do
        echo "  - ${app#*.}"  # Displaying the application name only
    done

    # Prompt user for confirmation to install applications
    read -p "Do you want to proceed with the installation? (Y/n): " install_choice
    if [[ "$install_choice" =~ ^[Nn]$ ]]; then
        print_msg "Skipping Flatpak application installation."
        return 0
    fi

    # Install Flatpak applications
    for app in "${flatpak_applications[@]}"; do
        if flatpak info "$app" &> /dev/null; then
            print_msg "$app is already installed, skipping."
        else
            print_msg "Installing Flatpak application: $app..."
            flatpak install -y flathub "$app" || print_error "Failed to install $app."
        fi
    done
}

# Call functions to install Flatpak and applications
install_flatpak
install_flatpak_apps
