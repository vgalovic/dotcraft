#!/bin/bash

source ~/.dotfiles/install/setup/print_and_log.sh

install_xorg() {
    print_msg "Installing Base System & Display Server"
    sudo apt install -y xorg xserver-xorg || {
        print_error "Failed to install base system"
        exit 1;
    }
    print_msg "Base System & Display Server Installed"
}

install_lightdm() {
    print_msg "Installing LightDM"
    sudo apt install -y lightdm lightdm-gtk-greeter || {
        print_error "Failed to install lightdm"
    }
    print_msg "LightDM Installed"
}

install_i3() {
    print_msg "Installing i3 wm"
    sudo apt-get install -y i3 || {
        print_error "Failed to install i3"
        exit 1;
    }
    print_msg "i3 wm Installed"
}

install_utils() {
    print_msg "Installing Essential Utilities"
    sudo apt install -y \
        polybar \
        i3lock \
        i3-gaps \
        rofi \
        feh \
        picom \
        x11-utils \
        x11-xkb-utils || {
        print_error "Failed to install essential utilities"
    }
    print_msg "Essential Utilities Installed"
}

install_network_manager() {
    print_msg "Installing Network Manager"
    sudo apt install -y \
        network-manager \
        network-manager-gnome || {
        print_error "Failed to install network manager"
    }
    print_msg "Network Manager Installed"
}

install_audio() {
    print_msg "Installing Audio Utilities"
    sudo apt install -y \
        pipewire  \
        pipewire-audio \
        pipewire-pulse \
        pipewire-alsa wireplumber \
        playerctl || {
        print_error "Failed to install audio utilities"
    }
    systemctl --user enable pipewire pipewire-pulse wireplumber || {
        print_error "Failed to enable audio utilities"
    }
    systemctl --user start pipewire pipewire-pulse wireplumber ||{
        print_error "Failed to start audio utilities"
    }
}

install_font_and_appearance() {
    print_msg "Installing Fonts and Appearance"
    sudo apt install -y fonts-dejavu fonts-ubuntu lxappearance || {
        print_error "Failed to install fonts and appearance"
        exit 1;
    }
    print_msg "Fonts and Appearance Installed"
}

install_file_manager() {
    print_msg "Installing File Manager"
    sudo apt install -y thunar thunar-archive-plugin ||  {
        print_error "Failed to install file manager"
    }
    print_msg "File Manager Installed"
}

install_power_management() {
    print_msg "Installing Power Management"
    sudo apt install -y acpi acpid upower || {
        print_error "Failed to install power management"
    }
    print_msg "Power Management Installed"
}

install_brightness_control() {
    print_msg "Installing Brightness Control"
    sudo apt install -y brightnessctl || {
        print_error "Failed to install brightness control"
    }
    print_msg "Brightness Control Installed"
}

install_bluetooth() {
    print_msg "Installing Bluetooth"
    sudo apt install -y blueman bluez || {
        print_error "Failed to install bluetooth"
    }
    print_msg "Bluetooth Installed"
}

echo "If you are installing i3 wm, on clean system without any other window manager or desktop environment, it is recommended to install all packages in this script."

if prompt_yes_default "Install Base System & Display Server"; then
    install_xorg
fi

if prompt_yes_default "Install LightDM"; then
    install_lightdm
fi

if prompt_yes_default "Install i3 wm"; then
    install_i3
fi

if prompt_yes_default "Install Essential Utilities"; then
    install_utils
fi

if prompt_yes_default "Install Network Manager"; then
    install_network_manager
fi

if prompt_yes_default "Install Audio Utilities"; then
    install_audio
fi

if prompt_yes_default "Install Fonts and Appearance"; then
    install_font_and_appearance
fi

if prompt_yes_default "Install File Manager"; then
    install_file_manager
fi

if prompt_yes_default "Install Power Management"; then
    install_power_management
fi

if prompt_yes_default "Install Brightness Control"; then
    install_brightness_control
fi

if prompt_yes_default "Install Bluetooth"; then
    install_bluetooth
fi

