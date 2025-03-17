#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to detect package manager
detect_package_manager() {
    if command -v apt &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    else
        echo "unknown"
    fi
}

PKG_MANAGER=$(detect_package_manager)

# Function to check if a repository exists
repository_exists() {
    if [ "$PKG_MANAGER" = "apt" ]; then
        grep -h "^deb .*papirus/papirus" /etc/apt/sources.list /etc/apt/sources.list.d/* &> /dev/null
    else
        echo "Skipping repository check for DNF."
    fi
}

# Function to add Papirus repository
add_repository() {
    if [ "$PKG_MANAGER" = "apt" ]; then
        if repository_exists; then
            print_msg "Papirus repository already exists."
        else
            print_msg "Adding Papirus repository..."
            sudo add-apt-repository -y ppa:papirus/papirus || { print_error "Failed to add Papirus repository."; exit 1; }
            print_msg "Updating package index..."
            sudo apt update || { print_error "Failed to update package index."; exit 1; }
        fi
    fi
}

# Function to install packages
install_package() {
    local package="$1"
    print_msg "Installing $package..."
    if [ "$PKG_MANAGER" = "apt" ]; then
        sudo apt install -y "$package" || print_error "Failed to install $package."
    elif [ "$PKG_MANAGER" = "dnf" ]; then
        sudo dnf install -y "$package" || print_error "Failed to install $package."
    else
        print_error "Unsupported package manager. Exiting."
        exit 1
    fi
    print_msg "$package installation completed!"
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

install_kvantum() {
    if [ "$PKG_MANAGER" = "apt" ]; then
        install_package "qt5-style-kvantum"
        install_package "qt6-style-kvantum"
        install_package "qt5-style-kvantum-themes"
    elif [ "$PKG_MANAGER" = "dnf" ]; then
        install_package "kvantum"
        install_package "kvantum-qt5"
        install_package "kvantum-qt6"
    else
        print_error "Unsupported package manager. Exiting."
        exit 1
    fi

    print_msg "Kvantum installation completed!"
}

# Function to install Papirus icon theme and Kvantum styles
install_papirus_kvantum() {
    local default_option=3 # Default to "Both"

    # Display options using the built-in select command
    PS3="Choose an option to install: "
    options=("Skip" "Papirus icon theme" "Kvantum style manager (Qt)" "Both")
    select opt in "${options[@]}"; do
        case "$opt" in
            "Skip")
                print_msg "Skipping installation."
                break
                ;;
            "Papirus icon theme")
                add_repository
                install_package "papirus-icon-theme"
                break
                ;;
            "Kvantum style manager (Qt)")
                add_repository
                install_kvantum
                set_kvantum_paths
                break
                ;;
            "Both")
                add_repository
                 install_package "papirus-icon-theme"
                 install_kvantum
                set_kvantum_paths
                break
                ;;
            *)
                print_error "Unexpected error. Exiting."
                exit 1
                ;;
        esac
    done
}

# Main script logic
if [[ "$XDG_CURRENT_DESKTOP" != "KDE" ]]; then
    # Call the function only if the desktop is NOT KDE
    install_papirus_kvantum
else
    print_msg "KDE detected. There is no need for installing Kvantum on this system."
    if prompt_yes_default_no "Do you want to install Papirus icon theme?"; then
        add_repository
        install_package "papirus-icon-theme"
    fi
fi
