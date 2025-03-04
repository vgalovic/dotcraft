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

# Function to load applications from file into an array
load_brew_applications() {
    APP_DIR="$HOME/.dotfiles/install/app_list"
    local file="$APP_DIR/brew_applications.txt"
    brew_applications=()

    if [[ -f "$file" ]]; then
        print_msg "Loading Homebrew applications from $file..."
        while IFS= read -r app; do
            if [[ -n "$app" && ! "$app" =~ ^# ]]; then
                brew_applications+=("$app")
            fi
        done < "$file"

        [[ ${#brew_applications[@]} -gt 0 ]] || print_warning "No valid applications found in $file."
    else
        print_error "$file not found. Skipping application installation."
    fi
}

# Function to retry installation with specified attempts
install_with_retries() {
    local app="$1"
    local attempt=0
    local max_attempts=3

    while [[ $attempt -lt $max_attempts ]]; do
        print_msg "Installing $app..."
        if brew install "$app"; then
            print_msg "$app installed successfully."
            return 0
        else
            print_error "Failed to install $app. Retrying..."
            ((attempt++))
        fi
    done
    print_error "Exceeded maximum attempts to install $app. Skipping."
    return 1
}

# Function to install default applications from brew_applications.txt
install_brew_default() {
    load_brew_applications

    if [[ ${#brew_applications[@]} -gt 0 ]]; then
        local app_list
        app_list=$(IFS=", "; echo "${brew_applications[*]}")
        read -p "Install default applications ($app_list)? (Y/n): " install_default_choice
        if [[ -n "$install_default_choice" && ! "$install_default_choice" =~ ^[Yy]$ ]]; then
            print_msg "Skipping default applications installation."
            return 0
        fi

        for app in "${brew_applications[@]}"; do
            install_with_retries "$app"
        done

    fi
}

# Main script execution
install_brew
install_brew_default
