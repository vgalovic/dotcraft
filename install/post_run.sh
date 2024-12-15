#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"
echo "Post-installation log: $(date)" > "$LOG_FILE"

# Variables
SETUP_DIR="$HOME/.dotfiles/install/setup"

execute_script "setup_games"

execute_script "setup_colorscript"

execute_script "setup_anime"

if command -v mpv >/dev/null; then
    execute_script "setup_mpv_plugins"
fi

if command -v bat >/dev/null; then
    execute_script "setup_bat"
fi

if command -v yazi >/dev/null; then
    execute_script "setup_yazi_plugin"
fi

if command -v glow >/dev/null; then
    execute_script "setup_glow"
fi

