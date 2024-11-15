
#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"


# Set the download path to the current user's Downloads directory
download_path="$HOME/Downloads"

cleanup() {
    echo "Performing cleanup..."
    rm -f "$download_path/*-megasync-*.deb"
}

trap cleanup EXIT

# Function to detect all installed file managers
detect_file_managers() {
    local managers=()
    if command -v nautilus &> /dev/null; then
        managers+=("nautilus")
    fi
    if command -v nemo &> /dev/null; then
        managers+=("nemo")
    fi
    if command -v dolphin &> /dev/null; then
        managers+=("dolphin")
    fi
    if command -v thunar &> /dev/null; then
        managers+=("thunar")
    fi

    echo "${managers[@]}"
}

# Function to check Linux Mint or Ubuntu and determine the corresponding Ubuntu version
get_ubuntu_version() {
    if grep -iq "Linux Mint" /etc/os-release; then
        if command -v lsb_release &>/dev/null; then
            mint_version=$(lsb_release -rs)

            # Extract the major version number
            if [[ $mint_version =~ ^([0-9]+) ]]; then
                major_version="${BASH_REMATCH[1]}"

                # Check if the version is odd or even
                if (( major_version % 2 == 0 )); then
                    ubuntu_version=$((major_version + 2)).04
                else
                    ubuntu_version=$((major_version + 1)).04
                fi

                # Log the message without echoing it
                print_msg "Detected Linux Mint version $mint_version, corresponding to Ubuntu $ubuntu_version." >&2
                # Then echo the Ubuntu version to be used later
                echo "$ubuntu_version" 
            else
                print_error "Unsupported Linux Mint version: $mint_version." >&2
                return 1
            fi
        else
            print_error "The 'lsb_release' command is not available. Please install it to continue."
            return 1
        fi
    elif grep -iq "Ubuntu" /etc/os-release; then
        if command -v lsb_release &>/dev/null; then
            ubuntu_version=$(lsb_release -rs)
            print_msg "Detected Ubuntu version $ubuntu_version."
            echo "$ubuntu_version"
        else
            print_error "The 'lsb_release' command is not available. Please install it to continue."
            return 1
        fi
    else
        print_error "This script is intended for Ubuntu or Linux Mint."
        return 1
    fi
}

# Function to download and install MEGA Sync
download_and_install_mega_sync() {
    local ubuntu_version="$1"

    # Check if MEGA Sync is already installed
    if dpkg -l | grep -q megasync; then
        print_msg "MEGA Sync is already installed. Skipping installation."
        return 0
    fi
    
    megasync_path="$download_path/megasync-xUbuntu_${ubuntu_version}_amd64.deb"

    # Download MEGA Sync's deb file as the regular user
    print_msg "Downloading MEGA Sync's deb file..."
    wget -q "https://mega.nz/linux/repo/xUbuntu_${ubuntu_version}/amd64/megasync-xUbuntu_${ubuntu_version}_amd64.deb" -O "$megasync_path" || {
        print_error "Failed to download MEGA Sync's deb file."
        return 1
    }

    # Ensure the file has correct permissions for installation
    print_msg "Changing permissions of the downloaded file..."
    chmod 644 "$megasync_path" || {
        print_error "Failed to change permissions of the downloaded file."
        return 1
    }

    print_msg "Installing MEGA Sync..."
    sudo apt install -y "$megasync_path" || {
        print_error "Failed to install MEGA Sync."
        return 1
    }

    print_msg "Removing the MEGA Sync deb file..."
    rm "$megasync_path" || {
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

    file_manager_integration_path="$download_path/${file_manager}-megasync-xUbuntu_${ubuntu_version}_amd64.deb"

    # Download MEGA file manager integration deb file
    print_msg "Downloading MEGA file manager integration deb file for $file_manager..."
    wget -q "https://mega.nz/linux/repo/xUbuntu_${ubuntu_version}/amd64/${file_manager}-megasync-xUbuntu_${ubuntu_version}_amd64.deb" -O "$file_manager_integration_path" || {
        print_error "Failed to download MEGA file manager integration deb file for $file_manager."
        return 1
    }

    # Ensure the file has correct permissions for installation
    print_msg "Changing permissions of the downloaded file..."
    chmod 644 "$file_manager_integration_path" || {
        print_error "Failed to change permissions of the downloaded file."
        return 1
    }

    # Install MEGA file manager integration
    print_msg "Installing MEGA file manager integration for $file_manager..."
    sudo apt install -y "$file_manager_integration_path" || {
        print_error "Failed to install MEGA file manager integration."
        return 1
    }

    # Remove the downloaded deb file
    rm "$file_manager_integration_path" || {
        print_error "Failed to remove MEGA file manager integration's deb file."
    }
}

# Function to handle installation for all supported file managers
install_file_manager_integrations() {
    local ubuntu_version="$1"
    local file_managers
    file_managers=$(detect_file_managers)

    if [ -z "$file_managers" ]; then
        print_msg "No supported file managers found. Skipping integration installation."
        return
    fi

    for file_manager in $file_managers; do
        print_msg "Installing integration for $file_manager..."
        download_and_install_file_manager_integration "$file_manager" "$ubuntu_version" || {
            print_error "Failed to install integration for $file_manager."
        }
    done
}

# Main installation function
install_mega_sync() {
    # Get the Ubuntu version
    ubuntu_version=$(get_ubuntu_version)
    if [ $? -ne 0 ]; then
        print_error "Failed to determine Ubuntu version. Exiting."
        return 1
    fi

    print_msg "Download path: $download_path"

    # Download and install MEGA Sync
    print_msg "Downloading and installing MEGA Sync for Ubuntu $ubuntu_version..."
    if ! download_and_install_mega_sync "$ubuntu_version"; then
        print_error "Failed to download and install MEGA Sync. Exiting."
        return 1
    fi

    # Install file manager integrations for all supported file managers
    install_file_manager_integrations "$ubuntu_version"

    # Clean up unused packages
    print_msg "Cleaning up unnecessary packages..."
    if ! sudo apt autoremove -y; then
        print_error "Failed to clean up."
    fi

    print_msg "MEGA Sync installation completed!"
}

# Call the main installation function
install_mega_sync

