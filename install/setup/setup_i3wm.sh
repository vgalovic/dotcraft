#!/bin/bash

source ~/.dotfiles/install/setup/print_and_log.sh

# Enable Multiverse Repository
enable_multiverse() {
    print_msg "Enabling Multiverse"
    sudo add-apt-repository -y multiverse
    print_msg "Multiverse Enabled"

    print_msg "Update system"
    sudo apt update && sudo apt upgrade -y || {
        print_error "Failed to update system"
        exit 1
    }
    print_msg "System Updated"
}

# Install Power Management Tools
install_power_management() {
    print_msg "Installing Power Management Tools"
    sudo apt install -y \
        acpi-support \
        cpufrequtils \
        acpi \
        powertop \
        acpid \
        apmd \
        pm-utils \
        tlp \
        tlp-rdw || {
        print_error "Failed to install power management tools"
    }
    print_msg "Power Management Tools Installed"

    print_msg "Enabling TLP"
    sudo systemctl enable tlp || {
        print_error "Failed to enable TLP"
    }
    print_msg "TLP Enabled"
}

# Install Networking Tools
install_networking_tools() {
    print_msg "Installing Networking Tools"
    sudo apt install -y \
        wireless-tools \
        wpasupplicant \
        network-manager \
        avahi-autoipd \
        nm-applet || {
        print_error "Failed to install networking tools"
    }
    print_msg "Networking Tools Installed"
}

# Install Bluetooth Tools
install_bluetooth() {
    print_msg "Installing Bluetooth Tools"
    sudo apt install -y \
        bluetooth \
        bluez \
        blueman || {
        print_error "Failed to install Bluetooth tools"
    }
    print_msg "Bluetooth Tools Installed"
}

# Install Xorg and i3 Window Manager
install_xorg() {
    print_msg "Installing Xorg"
    sudo apt install -y \
        xorg \
        xserver-xorg || {
        print_error "Failed to install Xorg"
        exit 1
    }
    print_msg "Xorg Installed"
}

# Install i3 Window Manager
install_i3wm() {
    print_msg "Installing i3 wm"
    sudo apt-get install -y \
        i3 \
        i3-gaps || {
        print_error "Failed to install i3 wm"
        exit 1
    }
    print_msg "i3 wm Installed"
}

# Install LightDM
install_lightdm() {
    print_msg "Installing LightDM"
    sudo apt install -y \
        lightdm \
        lightdm-gtk-greeter || {
        print_error "Failed to install LightDM"
    }
    print_msg "LightDM Installed"
}

# Install Essential Utilities
install_utils() {
    print_msg "Installing Essential Utilities"
    sudo apt install -y \
        arandr \
        autorandr \
        dunst \
        polybar \
        i3lock \
        rofi \
        feh \
        picom \
        x11-utils \
        x11-xkb-utils \
        ibus \
        ibus-m17n || {
        print_error "Failed to install essential utilities"
    }
    print_msg "Essential Utilities Installed"
}

# Install Fonts and Appearance
install_font_and_appearance() {
    print_msg "Installing Fonts and Appearance"
    sudo apt install -y \
        fonts-dejavu \
        fonts-ubuntu \
        lxappearance || {
        print_error "Failed to install fonts and appearance"
        exit 1
    }
    print_msg "Fonts and Appearance Installed"
}

# Install File Manager
install_file_manager() {
    print_msg "Installing File Manager"
    sudo apt install -y \
        thunar \
        thunar-archive-plugin || {
        print_error "Failed to install file manager"
    }
    print_msg "File Manager Installed"
}

# Install Screenshot Utility
install_screenshot() {
    print_msg "Installing Screenshot Utility"
    sudo apt install -y flameshot || {
        print_error "Failed to install screenshot"
    }
    print_msg "Screenshot Utility Installed"
}

# Install Codecs
install_codecs() {
    print_msg "Installing Codecs"
    sudo apt install -y \
        ubuntu-restricted-extras \
        libavcodec-extra \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        ffmpeg \
        libdvd-pkg || {
        print_error "Failed to install codecs"
    }
    print_msg "Codecs Installed"

    sudo dpkg-reconfigure libdvd-pkg || {
        print_error "Failed to reconfigure codecs"
    }
}

# Install Audio Utilities
install_audio() {
    print_msg "Installing Audio Utilities"
    sudo apt install -y \
        pipewire \
        pipewire-audio \
        pipewire-pulse \
        pipewire-alsa \
        wireplumber \
        playerctl || {
        print_error "Failed to install audio utilities"
    }
    print_msg "Audio Utilities Installed"

    print_msg "Enabling Audio Utilities"
    systemctl --user enable pipewire pipewire-pulse wireplumber || {
        print_error "Failed to enable audio utilities"
    }
    print_msg "Audio Utilities Enabled"

    print_msg "Starting Audio Utilities"
    systemctl --user start pipewire pipewire-pulse wireplumber || {
        print_error "Failed to start audio utilities"
    }
    print_msg "Audio Utilities Started"
}

# Main Installation Flow
echo "\e[1;33mIf you are installing i3 wm, on clean system without any other window manager or desktop environment, it is recommended to install all packages in this script.\e[0m"

enable_multiverse

if prompt_yes_default "Install Xorg"; then
    install_xorg
fi

if prompt_yes_default "Install i3 wm"; then
    install_i3wm
fi

if prompt_yes_default "Install LightDM"; then
    install_lightdm
fi

if prompt_yes_default "Install Essential Utilities"; then
    install_utils
fi

if prompt_yes_default "Install Networking Tools"; then
    install_networking_tools
fi

if prompt_yes_default "Install Bluetooth Tools"; then
    install_bluetooth
fi

if prompt_yes_default "Install Power Management Tools"; then
    install_power_management
fi

if prompt_yes_default "Install Fonts and Appearance"; then
    install_font_and_appearance
fi

if prompt_yes_default "Install File Manager"; then
    install_file_manager
fi

if prompt_yes_default "Install Screenshot Utility"; then
    install_screenshot
fi

if prompt_yes_default "Install Codecs"; then
    install_codecs
fi

if prompt_yes_default "Install Audio Utilities"; then
    install_audio
fi
