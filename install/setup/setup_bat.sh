#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

removing_old_and_creating_new_directories() {
    if [ -d "$(bat --config-dir)/themes" ]; then
        print_msg "Bat themes directory already exists. Removing old directory..."
        rm -rf "$(bat --config-dir)/themes" || print_error "Failed to remove old bat themes directory."
    fi

    if [ -d "$(bat --config-dir)/syntaxes" ]; then
        print_msg "Bat syntaxes directory already exists. Removing old directory..."
        rm -rf "$(bat --config-dir)/syntaxes" || print_error "Failed to remove old bat syntaxes directory."
    fi

    mkdir -p "$(bat --config-dir)/themes" || print_error "Failed to create bat themes directory."
    mkdir -p "$(bat --config-dir)/syntaxes" || print_error "Failed to create bat syntaxes directory."
}

downloading_catppuccin_theme_file() {
    print_msg "Downloading Catppuccin Mocha theme file..."
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme || print_error "Failed to download Catppuccin Mocha theme file."
}

downloading_moonfly_theme_file() {
  print_msg "Downloading Moonfly theme file..."
    wget -P "$(bat --config-dir)/themes" https://github.com/bluz71/fly16-bat/raw/refs/heads/master/fly16.tmTheme || print_error "Failed to download Moonfly theme file."

}

downloading_syntax_files() {
    cd "$(bat --config-dir)/syntaxes" || print_error "Failed to change to bat syntaxes directory."

    print_msg "Downloading VHDL syntax file..."
    git clone https://github.com/TheClams/SmartVHDL.git  || print_error "Failed to clone VHDL syntax file."

    print_msg "Downloading Verilog syntax file..."
    git clone https://github.com/pro711/sublime-verilog.git || print_error "Failed to clone Verilog syntax file."

    print_msg "Downloading SystemVerilog syntax file..."
    git clone https://github.com/TheClams/SystemVerilog.git || print_error "Failed to clone SystemVerilog syntax file."
}

removing_old_and_creating_new_directories
downloading_catppuccin_theme_file
downloading_moonfly_theme_file
downloading_syntax_files

print_msg "Building bat cache..."
bat cache --build || print_error "Failed to build bat cache."

print_msg "Bat setup complete."
