#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to check if a repository exists
repository_exists() {
    grep -h "^deb .*papirus/papirus" /etc/apt/sources.list /etc/apt/sources.list.d/* &> /dev/null
}

# Function to add Papirus repository
add_repository() {
    if repository_exists; then
        print_msg "Papirus repository already exists."
    else
        print_msg "Adding Papirus repository..."
        sudo add-apt-repository -y ppa:papirus/papirus || { print_error "Failed to add Papirus repository."; exit 1; }
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

    if ! grep -q "kvantummanager" ~/.profile; then
        echo "$kvantum_paths" >> ~/.profile
        print_msg "Kvantum paths added to .profile."
    else
        print_msg "Kvantum paths are already present in .profile."
    fi
}

# Function to select options from a menu with a default option
select_option() {
    local prompt="$1"
    local default="$2" # Default option index (0-based)
    shift 2
    local options=("$@")

    # Display options with prompt and show the default option
    echo "$prompt (default: ${options[$default]}):"
    for i in "${!options[@]}"; do
        echo "  $((i + 1))) ${options[$i]}"
    done

    while true; do
        # Prompt for user input
        read -p "Select an option [1-${#options[@]}] (press Enter for default): " choice

        # If input is empty, set to default option
        if [[ -z "$choice" ]]; then
            REPLY=$((default + 1))  # Set the default option (1-based index)
            return
        elif [[ "$choice" =~ ^[1-9][0-9]*$ ]] && ((choice >= 1 && choice <= ${#options[@]})); then
            # Valid option selected
            REPLY=$choice
            return
        else
            echo "Invalid option. Please try again."
        fi
    done
}

# Install only Papirus icon theme
install_papirus_only() {
    print_msg "Installing Papirus icon theme..."
    add_repository
    sudo apt install -y papirus-icon-theme || print_error "Failed to install Papirus icon theme."
    print_msg "Papirus icon theme installation completed!"
}

# Function to install Papirus icon theme and Kvantum styles
install_papirus_kvantum() {
    local default_option=3 # Default to "Both"
    select_option "Choose an option to install" "$default_option" \
        "Skip" "Papirus icon theme" "Kvantum style manager (Qt)" "Both"

    case "$REPLY" in
        1)
            print_msg "Skipping installation."
        ;;
        2)
            print_msg "Installing Papirus icon theme..."
            add_repository
            sudo apt install -y papirus-icon-theme || print_error "Failed to install Papirus icon theme."
            print_msg "Papirus icon theme installation completed!"
        ;;
        3)
            print_msg "Installing Kvantum..."
            add_repository
            sudo apt install -y qt5-style-kvantum qt6-style-kvantum qt5-style-kvantum-themes || print_error "Failed to install Kvantum."
            print_msg "Kvantum installation completed!"
            set_kvantum_paths
        ;;
        4)
            print_msg "Installing both Papirus icon theme and Kvantum..."
            add_repository
            sudo apt install -y papirus-icon-theme qt5-style-kvantum qt6-style-kvantum qt5-style-kvantum-themes || print_error "Failed to install both Papirus icon theme and Kvantum."
            print_msg "Papirus icon theme and Kvantum installation completed!"
            set_kvantum_paths
        ;;
        *)
            print_error "Unexpected error. Exiting."
            exit 1
        ;;
    esac
}

# Main script logic
if [[ "$XDG_CURRENT_DESKTOP" =~ "KDE" ]]; then
    install_papirus_only
else
    install_papirus_kvantum
fi

