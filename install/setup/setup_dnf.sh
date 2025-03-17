#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to update package lists
update_dnf() {
    print_msg "Updating package lists..."
    sudo dnf update -y || { print_error "Failed to update package lists"; }
    sudo dnf upgrade -y || { print_error "Failed to upgrade system"; }
}

# Function to enable free and nonfree repositories
enable_repositories() {
    print_msg "Enabling free and nonfree repositories..."
    sudo dnf install -y fedora-workstation-repositories || print_error "Failed to install Fedora workstation repositories."
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm || print_error "Failed to enable RPM Fusion free repository."
    sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm || print_error "Failed to enable RPM Fusion nonfree repository."
    print_msg "Repositories enabled successfully."
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
            sudo dnf install -y wl-clipboard
            ;;
        x11)
            echo "Detected X11. Installing xclip..."
            sudo dnf install -y xclip
            ;;
        *)
            echo "Could not detect the compositor. Unable to install clipboard utility."
            exit 1
            ;;
    esac
}

# Function to install DNF applications
install_basic_dnf() {
    local dnf_applications=(
        "git"
        "hub"
        "curl"
        "wget"
    )

    for app in "${dnf_applications[@]}"; do
        print_msg "Installing DNF application: $app..."
        sudo dnf install -y "$app" || print_error "Failed to install $app via DNF"
    done
}

install_developer_apps() {
    local dnf_developer_tools=(
        "@development-tools"
        "glibc"
        "libgcc"
        "libstdc++"
        "gcc"
        "gcc-c++"
        "clang"
        "make"
        "cmake"
    )

    for app in "${dnf_developer_tools[@]}"; do
        print_msg "Installing DNF developer tool: $app..."
        sudo dnf install -y "$app" || print_error "Failed to install $app via DNF"
    done
}

install_avr() {
    local dnf_avr_tools=(
        "avr-gcc"
        "avr-libc"
        "avrdude"
        # "gdb-avr" # Not available in Fedora
        # "simulavr" # Not available in Fedora
    )

    for app in "${dnf_avr_tools[@]}"; do
        print_msg "Installing DNF AVR tool: $app..."
        sudo dnf install -y "$app" || print_error "Failed to install $app via DNF"
    done
}

install_github_cli() {
    print_msg "Installing GitHub CLI..."
    sudo dnf install -y gh || { print_error "Failed to install GitHub CLI."; }
    print_msg "GitHub CLI installed"
}

install_zsh() {
    print_msg "Installing ZSH..."
    sudo dnf install -y zsh || { print_error "Failed to install ZSH."; }
    print_msg "ZSH installed"

    if prompt_yes_default "Do you want to make ZSH your default shell?"; then
        sudo chsh -s /usr/bin/zsh || print_error "Failed to set ZSH as default shell."
        print_msg "ZSH set as default shell."
    fi
}

install_copyq () {
    print_msg "Installing CopyQ..."
    sudo dnf install -y copyq || print_error "Failed to install CopyQ."
    print_msg "CopyQ installation completed!"
}

install_conky () {
    print_msg "Installing conky..."
    sudo dnf install -y conky || print_error "Failed to install conky."
    print_msg "Conky installation completed!"
}

install_mpv () {
    print_msg "Installing mpv..."
    sudo dnf install -y mpv || print_error "Failed to install mpv."
    print_msg "MPV installation completed!"
}

install_zathura () {
    print_msg "Installing Zathura and plugins..."
    sudo dnf install -y zathura zathura-pdf-mupdf zathura-djvu zathura-ps || print_error "Failed to install Zathura and plugins."
    print_msg "Zathura installation completed!"
}

# Enable repositories
enable_repositories

# Update package lists
update_dnf

# Call the install_clipboard function
install_clipboard

# Install basic DNF applications
install_basic_dnf

# Install developer applications
if prompt_yes_default "Do you want to install developer applications?"; then
    install_developer_apps
fi

# Install AVR tools
if prompt_yes_default "Do you want to install AVR tools?"; then
    install_avr
fi

# Install GitHub CLI
if prompt_yes_default "Do you want to install GitHub CLI?"; then
    install_github_cli
fi

# Install ZSH
if prompt_yes_default "Do you want to install ZSH?"; then
    install_zsh
fi

# Check if running on KDE desktop environment
if [[ "$XDG_CURRENT_DESKTOP" != "KDE" ]]; then
    # Install CopyQ
    if prompt_yes_default "Do you want to install CopyQ?"; then
        install_copyq
    fi

    # Install Conky
    if prompt_yes_default "Do you want to install Conky?"; then
        install_conky
    fi
fi

# Install MPV
if prompt_yes_default "Do you want to install mpv?"; then
    install_mpv
fi

# Install Zathura
if prompt_yes_default "Do you want to install zathura?"; then
    install_zathura
fi
