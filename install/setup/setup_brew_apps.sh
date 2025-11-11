#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

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

install_brew_default
