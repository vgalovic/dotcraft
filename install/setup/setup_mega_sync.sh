#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to detect the file manager
detect_file_manager() {
    if command -v nautilus &> /dev/null; then
        echo "nautilus"
    elif command -v nemo &> /dev/null; then
        echo "nemo"
    elif command -v dolphin &> /dev/null; then
        echo "dolphin"
    elif command -v thunar &> /dev/null; then
        echo "thunar"
    else
        echo "none"
    fi
}

# Function to install MEGA Sync
install_mega_sync() {
    # Check for Linux Mint and determine the corresponding Ubuntu version
    if grep -q "Linux Mint" /etc/os-release; then
        mint_version=$(lsb_release -rs)

        # Extract the major version number
        if [[ $mint_version =~ ^([0-9]+) ]]; then
            major_version="${BASH_REMATCH[1]}"
            ubuntu_version=$((major_version + 2)).04
            print_msg "Detected Linux Mint version $mint_version, corresponding to Ubuntu $ubuntu_version."
        else
            print_error "Unsupported Linux Mint version: $mint_version."
            return 1
        fi
    elif grep -q "Ubuntu" /etc/os-release; then
        ubuntu_version=$(lsb_release -rs)
        print_msg "Detected Ubuntu version $ubuntu_version."
    else
        print_error "This script is intended for Ubuntu or Linux Mint."
        return 1
    fi

    # Download and install MEGA Sync
    download_and_install_mega_sync "$ubuntu_version"
    
    # Detect the file manager
    file_manager=$(detect_file_manager)

    # Check if a supported file manager is detected
    if [ "$file_manager" != "none" ]; then
        print_msg "Detected file manager: $file_manager"
        download_and_install_file_manager_integration "$file_manager" "$ubuntu_version"
    else
        print_msg "No supported file manager found. Skipping integration installation."
    fi

    # Clean up unused packages
    print_msg "Cleaning up unnecessary packages..."
    sudo apt autoremove -y || print_error "Failed to clean up."

    print_msg "MEGA Sync installation completed!"
}

# Function to download and install MEGA Sync
download_and_install_mega_sync() {
    local ubuntu_version="$1"

     # Check if MEGA Sync is already installed
    if dpkg -l | grep -q megasync; then
        print_msg "MEGA Sync is already installed. Skipping installation."
        return 0
    fi

    print_msg "Downloading MEGA Sync's deb file..."
    wget "https://mega.nz/linux/repo/xUbuntu_${ubuntu_version}/amd64/megasync-xUbuntu_${ubuntu_version}_amd64.deb" || {
        print_error "Failed to download MEGA Sync's deb file."
        return 1
    }

    print_msg "Installing MEGA Sync..."
    sudo apt install -y "./megasync-xUbuntu_${ubuntu_version}_amd64.deb" || {
        print_error "Failed to install MEGA Sync."
        return 1
    }

    print_msg "Removing the MEGA Sync deb file..."
    rm "./megasync-xUbuntu_${ubuntu_version}_amd64.deb" || {
        print_error "Failed to remove MEGA Sync's deb file."
    }
}

# Function to download and install file manager integration for MEGA Sync
download_and_install_file_manager_integration() {
    local file_manager="$1"
    local ubuntu_version="$2"

    # Check if file manager integration is already installed
    if dpkg -l | grep -q "${file_manager}-megasync"; then
        print_msg "${file_manager}-megasync is already installed. Skipping installation."
        return 0
    fi

    # Download MEGA file manager integration deb file
    print_msg "Downloading MEGA file manager integration deb file for $file_manager..."
    wget "https://mega.nz/linux/repo/xUbuntu_${ubuntu_version}/amd64/${file_manager}-megasync-xUbuntu_${ubuntu_version}_amd64.deb" || {
        print_error "Failed to download MEGA file manager integration deb file for $file_manager."
        return 1
    }

    # Install MEGA file manager integration
    print_msg "Installing MEGA file manager integration..."
    sudo apt install -y "./${file_manager}-megasync-xUbuntu_${ubuntu_version}_amd64.deb" || {
        print_error "Failed to install MEGA file manager integration."
        return 1
    }

    # Remove the downloaded file manager integration .deb file
    print_msg "Removing the MEGA file manager integration deb file..."
    rm "./${file_manager}-megasync-xUbuntu_${ubuntu_version}_amd64.deb" || {
        print_error "Failed to remove MEGA file manager integration's deb file."
    }
}

# Call the main installation function
install_mega_sync
