#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to check and install APT packages required for Yazi
install_yazi_apt_required() {
    local apt_yazi_required_apps=(
        "exiftool"
        "hexyl"
    )

    for app in "${apt_yazi_required_apps[@]}"; do
        print_msg "Checking if $app is installed..."

        if dpkg -l | grep -q "^ii  $app "; then
            print_msg "$app is already installed."
        else
            print_msg "Installing APT package: $app..."
            if ! sudo apt install -y "$app"; then
                print_error "Failed to install $app via APT."
            else
                print_msg "$app installed successfully."
            fi
        fi
    done
}

# Function to install Yazi plugins
install_yazi_plugins() {
    local plugin_dir="$HOME/.config/yazi/plugins/"

    # Create the plugin directory if it doesn't exist
    mkdir -p "$plugin_dir"

    # List of Yazi plugins to install
    declare -a plugins=(
        "https://github.com/sharklasers996/eza-preview.yazi.git" # eza-preview.yazi
    )

    # List of Ya plugins to install
    declare -a ya_plugins=(
        "yazi-rs/plugins:chmod" # chmod.yazi
        "Sonico98/exifaudio" # exifaudio.yazi
        "yazi-rs/plugins:full-border" # full-border.yazi
        "yazi-rs/plugins:git" # git.yazi
        "Reledia/hexyl" # hexyl.yazi
        "Lil-Dank/lazygit" # lazygit.yazi
        "AnirudhG07/rich-preview" # rich-preview.yazi
        "Rolv-Apneseth/starship" # starship.yazi
    )

    # Install each GitHub plugin
    for plugin in "${plugins[@]}"; do
        local plugin_name=$(basename "$plugin" .git)
        if [ ! -d "$plugin_dir/$plugin_name" ]; then
            print_msg "Installing $plugin_name..."
            if ! git clone "$plugin" "$plugin_dir/$plugin_name"; then
                print_error "Failed to clone $plugin_name."
            else
                print_msg "$plugin_name installed successfully."
            fi
        else
            print_msg "$plugin_name is already installed."
        fi
    done

    # Check if 'ya' command is available
    if ! command -v ya &> /dev/null; then
        print_error "'ya' command is not available. Skipping Ya plugin installation."
        return 1
    fi

    # Install each Ya plugin
    for ya_plugin in "${ya_plugins[@]}"; do
        print_msg "Installing ya plugin: $ya_plugin..."
        if ! ya pack -a "$ya_plugin"; then
            print_error "Failed to install ya plugin: $ya_plugin."
        else
            print_msg "$ya_plugin installed successfully."
        fi
    done
}

# If Yazi APT packages are needed
install_yazi_apt_required

# Main script execution
install_yazi_plugins

print_msg "Yazi plugins installation complete!"

