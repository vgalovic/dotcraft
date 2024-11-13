#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# Function to install Kitty terminal
install_kitty() {
    print_msg "Installing Kitty terminal..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin || { print_error "Failed to install Kitty terminal"; }

    # Set up directories and symlinks for Kitty
    mkdir -p ~/.local/bin/ || { print_error "Failed to create ~/.local/bin/ directory"; }
    mkdir -p ~/.local/share/applications/ || { print_error "Failed to create ~/.local/share/applications/ directory"; }
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/ || { print_error "Failed to create symlink for kitty"; }
    ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/ || { print_error "Failed to create symlink for kitten"; }
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/ || { print_error "Failed to copy kitty.desktop"; }
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/ || { print_error "Failed to copy kitty-open.desktop"; }
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop || { print_error "Failed to update icon path in kitty.desktop"; }
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop || { print_error "Failed to update exec path in kitty.desktop"; }
    echo 'kitty.desktop' > ~/.config/xdg-terminals.list || { print_error "Failed to create xdg-terminals list"; }
}

# Function to install Starship prompt
install_starship() {
    print_msg "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh || { print_error "Failed to install Starship prompt"; }
}

# Function to install JetBrains Mono Nerd Font
install_jetbrains_mono() {
    # Download the JetBrains Mono Nerd Font
    print_msg "Downloading JetBrains Mono Nerd Font..."
    if ! wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip; then
        print_error "Failed to download the font."
        return 1
    fi

    # Unzip the font
    print_msg "Unzipping JetBrains Mono Nerd Font..."
    if ! unzip -q JetBrainsMono.zip -d JetBrainsMono; then
        print_error "Failed to unzip the font."
        return 1
    fi

    # Create the local fonts directory if it doesn't exist
    mkdir -p ~/.local/share/fonts

    # Move the fonts to the local fonts directory
    print_msg "Installing JetBrains Mono Nerd Font..."
    if ! mv JetBrainsMono/*.ttf ~/.local/share/fonts/; then
        print_error "Failed to move fonts to the local directory."
        return 1
    fi

    # Refresh the font cache
    print_msg "Refreshing font cache..."
    if ! fc-cache -fv; then
        print_error "Failed to refresh the font cache."
        return 1
    fi

    # Clean up
    rm -rf JetBrainsMono JetBrainsMono.zip

    print_msg "JetBrains Mono Nerd Font installation complete!"
}

install_kitty
install_starship
install_jetbrains_mono
