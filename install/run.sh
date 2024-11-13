#!/bin/bash
# This script automates the setup of environment tools and applications.
# It will prompt for sudo access if not run with root permissions.

source "$HOME/.dotfiles/install/setup/print_and_log.sh"
echo "Installation log: $(date)" > "$LOG_FILE"

# Variables
SETUP_DIR="$HOME/.dotfiles/install/setup"

# Ensure SETUP_DIR exists
if [ ! -d "$SETUP_DIR" ]; then
    print_error "The directory $SETUP_DIR does not exist."
    exit 1
fi

# Function for a user prompt defaulting to 'Yes'
prompt_yes_default() {
    local prompt="$1"
    local choice
    read -p "$prompt (Y/n): " choice
    [[ -z "$choice" || "${choice,,}" == "y" ]]
}

# Function to run a setup script without prompting
must_execute_script() {
    local script_name="$1"
    print_msg "Running $script_name..."
    if [ -x "$SETUP_DIR/$script_name" ]; then
        if "$SETUP_DIR/$script_name"; then
            print_msg "Successfully ran $script_name."
        else
            print_error "Failed to run $script_name."
        fi
    else
        print_error "$script_name is not executable or not found."
    fi
}

# Function to execute a script with a user prompt
execute_script() {
    local script="$1"
    if prompt_yes_default "Do you want to install $script?"; then
        if "$SETUP_DIR/$script"; then
            print_msg "Successfully ran $script."
        else
            print_error "Failed to run $script."
        fi
    else
        print_msg "Skipping installation of $script."
    fi
}

# Run essential setup scripts without prompting
must_execute_script "setup_apt.sh"
must_execute_script "setup_kvantum_papirus.sh"

# Execute other setup scripts with user prompts
for script in setup_flatpack.sh setup_brew.sh setup_terminal_and_prompt.sh setup_mega_sync.sh setup_rust.sh setup_games.sh setup_ani-cli.sh; do
    execute_script "$script"
done

must_execute_script "setup_stow.sh"

# Helper function for downloading files
download_file() {
    local url="$1"
    local dest="$2"
    curl -fsSL "$url" -o "$dest" || print_error "Failed to download from $url"
}

# Download and install bash-preexec script
print_msg "Downloading bash-preexec script..."
download_file "https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh" "$HOME/.bash-preexec.sh"

if command -v mpv >/dev/null; then
    if prompt_yes_default "Do you want to install uosc (mpv skin)?" then
        print_msg "Downloading uosc..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh)" || print_error "Failed to download uosc"
        print_msg "uisc installed successfully."
    fi
fi

# Install Zen Browser
if prompt_yes_default "Do you want to install Zen browser?"; then
    if echo "1" | bash <(curl -s https://updates.zen-browser.app/appimage.sh); then
        print_msg "Zen browser installed successfully."
    else
        print_error "Failed to install Zen browser."
    fi
fi

# Install Zed Text Editor
if prompt_yes_default "Do you want to install Zed Tex Editor?"; then
    if curl -fsSL https://zed.dev/install.sh | sh; then
        print_msg "Zed Tex Editor installed successfully."
    else
        print_error "Failed to install Zed Tex Editor."
    fi
fi

# Completion message and reboot prompt
print_msg "Installation complete! Some changes may require a terminal restart to take effect."
if prompt_yes_default "Would you like to reboot now?"; then
    print_msg "Rebooting now..."
    sudo reboot
else
    print_msg "Reboot canceled. Please restart your terminal session for changes to take effect."
fi

