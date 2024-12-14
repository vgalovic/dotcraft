#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to update package lists
update_apt() {
    print_msg "Updating package lists..."
    sudo apt update || { print_error "Failed to update package lists"; }
    sudo apt upgrade -y || { print_error "Failed to upgrade system"; }
}

detect_compositor() {
    if [ -n "$WAYLAND_DISPLAY" ]; then
        echo "wayland"
    elif [ -n "$DISPLAY" ]; then
        echo "x11"
    else
        echo "unknown"
    fi
}

# Function to install the clipboard utility for X11 or Wayland
install_clipboard() {
    compositor=$(detect_compositor)

    case $compositor in
        wayland)
            echo "Detected Wayland. Installing wl-clipboard..."
            sudo apt install -y wl-clipboard
            ;;
        x11)
            echo "Detected X11. Installing xclip..."
            sudo apt install -y xclip
            ;;
        *)
            echo "Could not detect the compositor. Unable to install clipboard utility."
            exit 1
            ;;
    esac
}

# Function to install APT applications
install_basic_apt() {
    local apt_applications=(
        "git"
        "hub"
        "curl"
        "wget"
   )

    for app in "${apt_applications[@]}"; do
        print_msg "Installing APT application: $app..."
        sudo apt install -y "$app" || print_error "Failed to install $app via APT"
    done
}

install_developer_apps() {
     local apt_developer_tools=(
        "build-essential"
        "libc6"
        "libgcc-s1"
        "libstdc++6"
        "libsystemc"
        "libsystemc-dev"
        "gcc-multilib"
        "g++"
        "clang"
        "make"
        "cmake"
    )

    for app in "${apt_developer_tools[@]}"; do
        print_msg "Installing APT developer tool: $app..."
        sudo apt install -y "$app" || print_error "Failed to install $app via APT"
    done
}

install_avr() {
    local apt_avr_tools=(
     "gcc-avr"
     "avr-libc"
     "avrdude"
     "gdb-avr"
     "simulavr"
    )

    for app in "${apt_avr_tools[@]}"; do
        print_msg "Installing APT avr tool: $app..."
        sudo apt install -y "$app" || print_error "Failed to install $app via APT"
    done
}

install_github_cli() {
    print_msg "Installing GitHub CLI..."
    sudo apt install gh || { print_error "Failed to install GitHub CLI."; }
    print_msg "GitHub CLI installed"
}

install_zsh() {
    print_msg "Installing ZSH..."
    sudo apt install -y zsh || { print_error "Failed to install ZSH."; }
    print_msg "ZSH installed"

    if prompt_yes_default "Do you want to make ZSH your default shell?"; then
        sudo chsh -s /usr/bin/zsh || print_error "Failed to set ZSH as default shell."
        print_msg "ZSH set as default shell."
    fi
}

set_kvantum_paths() {
    # Define Kvantum paths configuration
    kvantum_paths='
    # Check for Kvantum and set QT_STYLE_OVERRIDE
    if command -v kvantummanager >/dev/null 2>&1; then
        export QT_STYLE_OVERRIDE=kvantum
    fi
    '

    # Check if Kvantum paths are already in .profile, and add them if not
    if ! grep -q "QT_STYLE_OVERRIDE=kvantum" ~/.profile; then
        echo "$kvantum_paths" >> ~/.profile
        print_msg "Kvantum paths added to .profile."
    else
        print_msg "Kvantum paths are already present in .profile."
    fi
}

install_copyq () {
     print_msg "Installing CopyQ..."
    sudo apt install -y copyq || print_error "Failed to install CopyQ."
    print_msg "CopuQ installation completed!"

}

install_conky () {
     print_msg "Installing conky..."
    sudo apt install -y conky-all || print_error "Failed to install conky."
    print_msg "conky installation completed!"
}
install_mpv () {
    print_msg "installing mpv..."
    sudo apt install -y mpv || print_error "Failed to install mopv."
    print_msg "mpv installation completed!"
}

# Update package lists
update_apt

# Call the install_clipboard function
install_clipboard

# Install basic APT applications
install_basic_apt

# Install developer applications
if prompt_yes_default "Do you want to install developer applications?"; then
    install_developer_apps
fi

# Install avr tools
if prompt_yes_default "Do you want to install avr tools?"; then
    install_avr
fi

# Install Github CLI
if prompt_yes_default "Do you want to install GitHub CLI?"; then
    install_github_cli
fi

# Install ZSH
if prompt_yes_default "Do you want to install ZSH?"; then
    install_zsh
fi

# Install CopyQ
if prompt_yes_default "Do you want to install CopyQ?"; then
    install_copyq
fi

# Install Conky
if prompt_yes_default "Do you want to install conky?"; then
    install_conky
fi

# Install MPV
if prompt_yes_default "Do you want to install mpv?"; then
    install_mpv
fi
