#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

add_brew_path() {
    print_msg "Linuxbrew is installed. Adding to PATH in .bashrc..."

    # Define Linuxbrew paths configuration
    linuxbrew_paths='
    # Check if Linuxbrew is installed and set up environment variables and paths
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        # Initialize Homebrew environment variables
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        # Include Linuxbrew bin and sbin in PATH
        PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
        PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"

        # Include Linuxbrew man pages in MANPATH
        MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"

        # Include Linuxbrew info pages in INFOPATH
        INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
    fi
    '

    # Check if Linuxbrew paths are already in .profile, and add them if not
    if ! grep -q "/home/linuxbrew/.linuxbrew" ~/.profile; then
        echo "$linuxbrew_paths" >> ~/.profile
        print_msg "Linuxbrew paths added to .profile."
    else
        print_msg "Linuxbrew paths are already present in .profile."
    fi
}

set_brew_path() {
    # Initialize Homebrew environment variables
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Load the new PATH in the current session
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    export PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"

    print_msg "Homebrew environment variables have been set."
}


# Function to install Homebrew
install_brew() {
    print_msg "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        print_error "Failed to install Homebrew";
        return 1;
    }

    add_brew_path
    set_brew_path
}

# Main script execution
install_brew
