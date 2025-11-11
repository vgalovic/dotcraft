#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"
echo "Post-installation log: $(date)" > "$LOG_FILE"

# Variables
SETUP_DIR="$HOME/.dotfiles/install/setup"

execute_script "setup_games"

execute_script "setup_colorscript"

execute_script "setup_anime"

if command -v nvim >/dev/null; then
    NVIM_PATH=$(command -v nvim)
    print_msg "Setting up Neovim as sudoedit"
    if sudo update-alternatives --install /usr/bin/editor editor "$NVIM_PATH" 100; then
        sudo update-alternatives --config editor
    else
        print_error "Failed to set up Neovim as sudoedit."
    fi
fi

if command -v kitty >/dev/null; then
    KITTY_PATH=$(command -v kitty)
    print_msg "Setting up Neovim as sudoedit"
    if sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$KITTY_PATH" 100; then
        sudo update-alternatives --config x-terminal-emulator
    else
        print_error "Failed to set up Neovim as sudoedit."
    fi
fi

if command -v cargo >/dev/null; then
    must_execute_script "setup_cargo_apps"
fi

if command -v bew >/dev/null; then
    must_execute_script "setup_brew_apps"
fi

if command -v mpv >/dev/null; then
    execute_script "setup_mpv_plugins"
fi

if command -v bat >/dev/null; then
    execute_script "setup_bat"
fi

if command -v yazi >/dev/null; then
    execute_script "setup_yazi_plugin"
fi

if command -v zathura >/dev/null; then
    execute_script "setup_zathura"
fi
