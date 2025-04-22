#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

yazi_dir="$HOME/.config/yazi"
plugin_dir="$yazi_dir/plugins"

if [ -f "$HOME/.config/yazi/package.toml" ]; then
    print_msg "pace.toml already exists. Removing old file..."
    rm "$HOME/.config/yazi/package.toml" || print_error "Failed to remove old pace.toml file."
fi

if [ -d "$HOME/.config/yazi/plugins" ]; then
    print_msg "plugins directory already exists. Removing old directory..."
    rm -rf "$HOME/.config/yazi/plugins" || print_error "Failed to remove old plugins directory."
fi

if [ -d "$HOME/.config/yazi/flavors" ]; then
    print_msg "flavors directory already exists. Removing old directory..."
    rm -rf "$HOME/.config/yazi/flavors" || print_error "Failed to remove old flavors directory."
fi

# Function to check and install APT packages required for Yazi
install_yazi_app_required() {
    local yazi_required_apps=(
        "exiftool"
        "hexyl"
    )

    for app in "${yazi_required_apps[@]}"; do
        print_msg "Checking if $app is installed..."

        if command -v "$app" &> /dev/null; then
            print_msg "$app is already installed."
        else
            print_msg "Installing APT package: $app..."
            if command -v apt &> /dev/null; then
                if ! sudo apt install -y "$app"; then
                    print_error "Failed to install $app via APT."
                else
                    print_msg "$app installed successfully."
                fi
            else if command -v dnf &> /dev/null; then
                    if ! sudo dnf install -y "$app"; then
                        print_error "Failed to install $app via DNF."
                    else
                        print_msg "$app installed successfully."
                    fi
                else
                    print_error "Failed to install $app. Please install it manually."
                fi
            fi
        fi
    done
}

# Function to install Yazi plugins
install_yazi_plugins() {
    # Create the plugin directory if it doesn't exist
    mkdir -p "$plugin_dir" || { print_error "Failed to create $plugin_dir directory."; return 1; }

    # List of Yazi plugins to install
    declare -a plugins=(
    )

    # List of Ya plugins to install
    declare -a ya_plugins=(
        "yazi-rs/plugins:chmod" # [[ chmod.yazi ]]
        "Sonico98/exifaudio" # [[ exifaudio.yazi ]]
        "ahkohd/eza-preview" # [[ eza-preview.yazi ]]
        "yazi-rs/plugins:full-border" # [[ full-border.yazi ]]
        "yazi-rs/plugins:git" # [[ git.yazi ]]
        "Reledia/glow" # [[ glow.yazi ]]
        "Reledia/hexyl" # [[ hexyl.yazi ]]
        "Lil-Dank/lazygit" # [[ lazygit.yazi ]]
        "tkapias/moonfly" # [[ moonfly.yazi ]]
        "AnirudhG07/rich-preview" # [[ rich-preview.yazi ]]
        "Rolv-Apneseth/starship" # [[ starship.yazi ]]
        "yazi-rs/plugins:toggle-pane" # [[ toggle-pane.yazi ]]
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
    else
        # Install each Ya plugin
        for ya_plugin in "${ya_plugins[@]}"; do
            print_msg "Installing ya plugin: $ya_plugin..."
            if ! ya pack -a "$ya_plugin"; then
                print_error "Failed to install ya plugin: $ya_plugin."
            else
                print_msg "$ya_plugin installed successfully."
            fi
        done
    fi
}

# Yazi cattpuccin theme
download_catppuccin_mocha_flavor() {
    print_msg "Downloading catppuccin-mocha theme..."
    cd "$yazi_dir" || print_error "Failed to change to $yazi_dir directory."
    mkdir -p "flavors/catppuccin-mocha.yazi" || print_error "Failed to create catppuccin-mocha.yazi directory"
    cd "flavors/catppuccin-mocha.yazi" || print_error "Faild to cahnge to catppuccin-mocha.yazi directory"
    wget https://raw.githubusercontent.com/catppuccin/yazi/refs/heads/main/themes/mocha/catppuccin-mocha-blue.toml || print_error "Failed to download catppuccin-mocha theme."
    wget https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme || print_error "Failed to download catppuccin-mocha syntax highlighting."
    mv catppuccin-mocha-blue.toml flavor.toml || print_error "Failed to move catppuccin-mocha theme."
    mv 'Catppuccin Mocha.tmTheme' tmtheme.xml || print_error "Failed to move catppuccin-mocha syntax highlighting."
}

download_catppuccin_latte_flavor() {
    print_msg "Downloading catppuccin-latte theme..."
    cd "$yazi_dir" || print_error "Failed to change to $yazi_dir directory."
    mkdir -p "flavors/catppuccin-latte.yazi" || print_error "Failed to create catppuccin-latte.yazi directory"
    cd "flavors/catppuccin-latte.yazi" || print_error "Faild to cahnge to catppuccin-latte.yazi directory"
    wget https://github.com/catppuccin/yazi/raw/refs/heads/main/themes/latte/catppuccin-latte-blue.toml || print_error "Failed to download catppuccin-latte theme."
    wget https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme || print_error "Failed to download catppuccin-latte syntax highlighting."
    mv catppuccin-latte-blue.toml flavor.toml || print_error "Failed to move catppuccin-latte theme."
    mv 'Catppuccin Latte.tmTheme' tmtheme.xml || print_error "Failed to move catpcatppuccin-lattepuccin syntax highlighting."
}

# If Yazi APT packages are needed
install_yazi_app_required

# Main script execution
install_yazi_plugins

# Install Yazi catppuccin theme
download_catppuccin_mocha_flavor
download_catppuccin_latte_flavor

print_msg "Yazi plugins installation complete!"

