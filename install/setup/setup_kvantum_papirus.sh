#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to check if a repository exists
repository_exists() {
    grep -h "^deb .*papirus/papirus" /etc/apt/sources.list /etc/apt/sources.list.d/* &> /dev/null
}

# Function to add Papirus repository
add_repository() {
    # Add Papirus repository if it doesn't already exist
    if repository_exists; then
        print_msg "Papirus repository already exists."
    else
        print_msg "Adding Papirus repository..."
        sudo add-apt-repository -y ppa:papirus/papirus || { print_error "Failed to add Papirus repository."; exit 1; }

        # Update package index
        print_msg "Updating package index..."
        sudo apt update || { print_error "Failed to update package index."; exit 1; }
    fi
}

# Function to set Kvantum paths (including QT_STYLE_OVERRIDE)
set_kvantum_paths() {
    print_msg "Setting Kvantum paths..."

    kvantum_paths='
    # Check for Kvantum and set QT_STYLE_OVERRIDE
    if command -v kvantummanager >/dev/null 2>&1; then
        export QT_STYLE_OVERRIDE=kvantum
    fi
    '

    # Check if Kvantum paths are already in .profile, and add them if not
    if ! grep -q "kvantummanager" ~/.profile; then
        echo "$kvantum_paths" >> ~/.profile
        print_msg "Kvantum paths added to .profile."
    else
        print_msg "Kvantum paths are already present in .profile."
    fi
}

# Function for a user prompt defaulting to 'Yes'
prompt_yes_default() {
    local prompt="$1"
    local choice
    read -p "$prompt (Y/n): " choice
    [[ -z "$choice" || "${choice,,}" == "y" ]]
}

# Function to select options from a menu, starting numbering from 0
select_option() {
    local prompt="$1"
    shift
    local options=("$@")
    PS3="$prompt: "
    select opt in "${options[@]}"; do
        if [[ -n "$opt" && $REPLY -ge 0 && $REPLY -lt ${#options[@]} ]]; then
            echo "$opt"
            break
        else
            echo "Invalid option. Please select a valid number."
        fi
    done
}

# Install only Papirus icon theme
install_papirus_only() {
    if prompt_yes_default "Do you want to install Papirus icons?"; then
        add_repository

        print_msg "Installing Papirus icon theme..."
        sudo apt install -y papirus-icon-theme || print_error "Failed to install Papirus icon theme."
        print_msg "Papirus icon theme installation completed!"
    else
        echo "Skipping installation."
        return 0
    fi
}

# Function to install Papirus icon theme and Kvantum styles
install_papirus_kvantum() {
    select_option "Choose an option to install" "Skip" "Papirus icon theme" "Kvantum style manager (Qt)" "Install both Papirus icon theme and Kvantum"

    case $REPLY in
        0)
            print_msg "Skipping installation."
            return 0
        ;;
        1)
            print_msg "Installing Papirus icon theme..."
            sudo apt install -y papirus-icon-theme || print_error "Failed to install Papirus icon theme."
            print_msg "Papirus icon theme installation completed!"
        ;;
        2)
            print_msg "Installing Kvantum..."
            sudo apt install -y qt5-style-kvantum qt6-style-kvantum qt5-style-kvantum-themes || print_error "Failed to install Kvantum."
            print_msg "Kvantum installation completed!"
            set_kvantum_paths
        ;;
        3)
            print_msg "Installing both Papirus icon theme and Kvantum..."
            sudo apt install -y papirus-icon-theme qt5-style-kvantum qt6-style-kvantum qt5-style-kvantum-themes || print_error "Failed to install both Papirus icon theme and Kvantum."
            print_msg "Papirus icon theme and Kvantum installation completed!"
            set_kvantum_paths
        ;;
        *)
            print_error "Invalid option. Skipping installation."
        ;;
    esac
}

# Main script logic
if [[ "$XDG_CURRENT_DESKTOP" =~ "KDE" ]]; then
    install_papirus_only
else
    install_papirus_kvantum
fi
