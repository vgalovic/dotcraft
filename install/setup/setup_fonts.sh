#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to remove everything inside FONT_DIR
remove_old_fonts() {
    local CACHE_DIR="$1"
    local FONT_DIR="$2"

    # Check if FONT_DIR is empty
    if [ -z "$(ls -A "$FONT_DIR")" ]; then
        print_msg "$FONT_DIR is empty. No need to remove anything."
        return 0
    fi

    print_msg "Removing all files and directories from $FONT_DIR..."

    # Remove everything inside the FONT_DIR (files and subdirectories)
    if ! rm -rf "$CACHE_DIR"/*; then
        print_error "Failed to remove old fonts or files."
        return 1
    fi

    if ! rm -rf "$FONT_DIR"/*; then
        print_error "Failed to remove old fonts or files."
        return 1
    fi

    print_msg "All old fonts and files removed successfully!"
}

# Function to download JetBrains Mono Nerd Font
jetbrains_mono() {
    local FONT_DIR="$1"
    local DOWNLOAD_DIR="$FONT_DIR/JetBrainsMonoNerdFont"

    REPO="ryanoasis/nerd-fonts"

    print_msg "Fetching latest JetBrains Mono Nerd Font release..."
    LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r '.tag_name')

    if [[ -z "$LATEST_TAG" || "$LATEST_TAG" == "null" ]]; then
        print_error "Failed to get the latest tag for JetBrains Mono."
        return 1
    fi

    print_msg "Latest JetBrains Mono Nerd Font version: $LATEST_TAG"

    DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_TAG/JetBrainsMono.zip"

    mkdir -p "$DOWNLOAD_DIR"

    print_msg "Downloading JetBrains Mono Nerd Font..."
    if ! curl -L -o "$DOWNLOAD_DIR/JetBrainsMono.zip" "$DOWNLOAD_URL"; then
        print_error "Failed to download JetBrains Mono Nerd Font."
        return 1
    fi

    print_msg "Extracting JetBrains Mono Nerd Font..."
    if ! unzip -o "$DOWNLOAD_DIR/JetBrainsMono.zip" -d "$DOWNLOAD_DIR"; then
        print_error "Failed to extract JetBrains Mono Nerd Font."
        return 1
    fi

    # Remove the .zip file
    print_msg "Cleaning up..."
    rm -f "$DOWNLOAD_DIR/JetBrainsMono.zip"  # Remove the .zip file

    print_msg "JetBrains Mono Nerd Font installed successfully!"
}

# Function to download Font Awesome
font_awesome() {
    FONT_DIR="$1"
    REPO="FortAwesome/Font-Awesome"

    # Get the latest release tag
    LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r '.tag_name')

    if [[ -z "$LATEST_TAG" || "$LATEST_TAG" == "null" ]]; then
        print_error "Failed to get the latest tag for Font Awesome."
        return 1
    fi

    DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_TAG/fontawesome-free-$LATEST_TAG-desktop.zip"

    mkdir -p "$DOWNLOAD_DIR"

    print_msg "Downloading Font Awesome..."
    if ! curl -L -o "$FONT_DIR/fontawesome.zip" "$DOWNLOAD_URL"; then
        print_error "Failed to download Font Awesome."
        return 1
    fi

    # Unzip the font
    print_msg "Extracting Font Awesome..."
    if ! unzip -o "$FONT_DIR/fontawesome.zip" -d "$FONT_DIR"; then
        print_error "Failed to extract Font Awesome."
        return 1
    fi

    # Clean up
    rm -rf "$FONT_DIR/fontawesome.zip"

    print_msg "Font Awesome font installed successfully!"
}

# Function to download Anurati font
anurati() {
    FONT_DIR="$1"
    DOWNLOAD_URL="https://www.dafontfree.co/wp-content/uploads/download-manager-files/Anurati_Free_Font.zip"
    DOWNLOAD_DIR="$FONT_DIR/Anurati-Free"

    mkdir -p "$DOWNLOAD_DIR"

    print_msg "Downloading Anurati font..."
    if ! curl -L -o "$DOWNLOAD_DIR/Anurati-Free.zip" "$DOWNLOAD_URL"; then
        print_error "Failed to download Anurati font."
        return 1
    fi

    # Unzip the font
    print_msg "Extracting Anurati font..."
    if ! unzip -o "$DOWNLOAD_DIR/Anurati-Free.zip" -d "$DOWNLOAD_DIR"; then
        print_error "Failed to extract Anurati font."
        return 2
    fi

    # Clean up
    rm -rf "$DOWNLOAD_DIR/Anurati-Free.zip"

    print_msg "Anurati font installed successfully!"
}

# Function to download Beckman font
beckman() {
    FONT_DIR="$1"
    DOWNLOAD_URL="https://www.freebestfonts.com/download?fn=32545"
    DOWNLOAD_DIR="$FONT_DIR/Beckman-Free"

    mkdir -p "$DOWNLOAD_DIR"

    print_msg "Downloading Beckman font..."
    if ! curl -L -o "$DOWNLOAD_DIR/beckman.zip" "$DOWNLOAD_URL"; then
        print_error "Failed to download Beckman font."
        return 1
    fi

    # Unzip the font
    print_msg "Extracting Beckman font..."
    if ! unzip -o "$DOWNLOAD_DIR/beckman.zip" -d "$DOWNLOAD_DIR"; then
        print_error "Failed to extract Beckman font."
        return 2
    fi

    # Clean up
    rm -rf "$DOWNLOAD_DIR/beckman.zip" || print_error "Faild to clean up. Do it manually."

    print_msg "Beckman font installed successfully!"
}

cache_fonts() {
    local CACHE_DIR="$1"
    local MAX_RETRIES=3
    local RETRIES=0

    print_msg "Caching fonts..."

    # Create the cache directory if it doesn't exist
    mkdir -p "$CACHE_DIR"

    # Retry logic for fc-cache
    while [ $RETRIES -lt $MAX_RETRIES ]; do
        fc-cache -fv

        if [ $? -eq 0 ]; then
            print_msg "Fonts cached successfully!"
            return 0
        else
            print_error "fc-cache failed."
            print_msg "Retrying... (Attempt $((RETRIES+1))/$MAX_RETRIES)"
            RETRIES=$((RETRIES+1))
            sleep 2  # Optional: adds a 2-second delay before retrying
        fi
    done

    print_error "fc-cache failed after $MAX_RETRIES attempts."
    return 1
}

# Download microsoft fonts
microsoft_fonts() {
    print_msg "Installing Microsoft fonts"

    if command apt -v &>/dev/null; then
        sudo apt install ttf-mscorefonts-installer -y ||{ print_error "Failed to install microsoft fonts"; return 1 }
    elif command dnf -v &>/dev/null; then
        sudo dnf install curl cabextract xorg-x11-font-utils fontconfig ||{ print_error "Failed to install dependencies"; return 1 }
        sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm || {
            print_error "Failed to install Microsoft fonts"; return 1
        }
    fi

    print_msg "Installed Microsoft fonts"
}

# Function to download all fonts
download_fonts() {
    local CACHE_DIR="$HOME/.cache/fontconfig"
    local FONT_DIR="$HOME/.local/share/fonts"

    print_msg "Starting font download..."

    # Create fonts directory if it doesn't exist
    mkdir -p "$FONT_DIR"

    # Check if the directory is empty before asking to remove old fonts
    if [ -n "$(ls -A "$FONT_DIR")" ]; then
        if prompt_yes_default "Do you want to remove old fonts and files?"; then
            print_msg "Removing old fonts and files..."
            remove_old_fonts "$CACHE_DIR" "$FONT_DIR"
        else
            print_msg "Skipping removal of old fonts and files."
        fi
    else
        print_msg "$FONT_DIR is already empty. Skipping removal."
    fi

    # Download each font
    jetbrains_mono "$FONT_DIR"
    font_awesome "$FONT_DIR"
    anurati "$FONT_DIR"
    beckman "$FONT_DIR"

    cache_fonts "$CACHE_DIR"

    microsoft_fonts

    print_msg "All fonts downloaded successfully!"
}

# Run the download_fonts function
download_fonts
