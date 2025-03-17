#!/bin/bash
# This script automates the setup of environment tools and applications.
# It will prompt for sudo access if not run with root permissions.

source "$HOME/.dotfiles/install/setup/print_and_log.sh"
echo "Installation log: $(date)" > "$LOG_FILE"

# Ensure SETUP_DIR exists
if [ ! -d "$SETUP_DIR" ]; then
    print_error "The directory $SETUP_DIR does not exist."
    exit 1
fi

# Run essential setup scripts without prompting
if command -v apt >/dev/null; then
    must_execute_script "setup_apt"
elif command -v dnf >/dev/null; then
    must_execute_script "setup_dnf"
elif command -v pacman >/dev/null; then
    execute_script "setup_yay"
fi

must_execute_script "setup_kvantum_papirus"

# Execute setup scripts for install packages tools
for script in setup_rust setup_pipx setup_npm; do
    execute_script "$script"
done

execute_script "setup_flatpak"

if command -v dnf >/dev/null; then
    echo "There are packages that are seted up to be installed via Homebrew, but you are using Fedora which already has moust of packages to the latest version in its repos."
    PS3="Do you want to install applications via: "
    options=("dnf (recommended)" "Homebrew" "Skip")
    select opt in "${options[@]}"; do
        case "$opt" in
            "dnf (recommended)")
                print_msg "Installing packages via dnf..."
                must_execute_script "setup_dnf_alternative"
                break
                ;;
            "HomeBrew")
                print_msg "Installing packages via Homebrew..."
                must_execute_script "setup_brew"
                break
                ;;
            "Skip")
                print_msg "Skipping this part of the setup."
                break
                ;;
            *)
                print_error "Invalid option. Please select again."
                ;;
        esac
    done
else
    execute_script "setup_brew"
fi

# Execute other setup scripts with user prompts
for script in setup_terminal_and_prompt setup_fonts setup_mega_sync setup_latex ; do
    execute_script "$script"
done

must_execute_script "setup_stow"

# Helper function for downloading files
download_file() {
    local url="$1"
    local dest="$2"
    curl -fsSL "$url" -o "$dest" || print_error "Failed to download from $url"
}

if command -v bash >/dev/null; then
    # Download and install bash-preexec script
    print_msg "Downloading bash-preexec script..."
    download_file "https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh" "$HOME/.bash-preexec.sh"
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

