#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_ani-skip() {
    print_msg "Skipping ani-cli installation..."
    git clone https://github.com/synacktraa/ani-skip.git || { print_error "Failed to clone ani-skip repository."; return 1; }
    sudo cp ani-skip/ani-skip /usr/local/bin/ || { print_error "Failed to copy ani-skip binary."; return 1; }
    mkdir -p ~/.config/mpv/scripts && cp ani-skip/skip.lua ~/.config/mpv/scripts || print_error "Failed to copy ani-skip script."

    print_msg "ani-skip installation completed!"
}

install_fastanime() {
    if ! command -v fastanime &> /dev/null; then
        print_msg "uv is required. Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh || { print_error "Failed to install uv."; return 1; }
        print_msg "uv installation completed!"
    fi
    print_msg "Installing fastanime..."
    uv tool install "fastanime[standard]"   || print_error "Failed to install fastanime."
    print_msg "fastanime installation completed!"


    print_msg "Downloading FastAnime completions..."
    FASTANIME_URL="https://raw.githubusercontent.com/Benex254/FastAnime/master/completions/fastanime.bash"
    DEST_PATH="/home/vgalovic/.local/share/uv/tools/fastanime/fastanime.bash"

    curl -L --progress-bar "$FASTANIME_URL" -o "$DEST_PATH" || { print_error "Failed to download FastAnime completions."; return 1; }

    print_msg "fastanime complilations downloaded!"

    add_fastanime_to_path
}

install_dependencies() {
    print_msg "Installing ani-cli..."

    # Ensure mpv is installed
    if ! command -v mpv &> /dev/null; then
        print_msg "mpv is required. Installing mpv..."
        sudo apt install -y mpv || print_error "Failed to install mpv."
        print_msg "mpv installation completed!"
    fi

    # Ensure fzf is installed
    if ! command -v fzf &> /dev/null; then
        print_msg "fzf is required. Installing fzf..."
        sudo apt install -y fzf || print_error "Failed to install fzf."
        print_msg "fzf installation completed!"
    fi

    print_msg "Downloading yt-dlp binary..."
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp || print_error "Failed to download yt-dlp binary."
    sudo chmod a+rx /usr/local/bin/yt-dlp || print_error "Failed to set permissions for yt-dlp binary."
    print_msg "yt-dlp binary downloaded!"

    # Install ani-cli dependencies
    print_msg "Installing dependencies..."
    sudo apt install -y chafa ffmpeg ffmpegthumbnailer feh || print_error "Failed to install apt packaged dependencies."

    if ! command -v npm &> /dev/null; then
        print_msg "npm is required. Installing npm..."
        sudo apt install -y npm || print_error "Failed to install npm."
        print_msg "npm installation completed!"
    fi

    npm install webtorrent-cli -g || print_error "Failed to install webtorrent-cli."

    print_msg "dependencies installed!"

    if prompt_yes_default "Do you want to install ani-skip? [Y/n]: "; then
        install_ani-skip
    fi
}

install_dependencies
install_fastanime

