# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashenv if it exists
    if [ -f "$HOME/.bashenv" ]; then
        . "$HOME/.bashenv"
    fi

    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Check if Linuxbrew is installed and set up environment variables and paths
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    # Initialize Homebrew environment variables
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Include Linuxbrew bin and bin in PATH
    PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

    # Include Linuxbrew sbin and bin in PATH
    PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"

    # Include Linuxbrew man pages in MANPATH
    MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"

    # Include Linuxbrew info pages in INFOPATH
    INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
fi

# Source Cargo environment if present
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# Check for Kvantum and set QT_STYLE_OVERRIDE
if command -v kvantummanager >/dev/null 2>&1; then
    export QT_STYLE_OVERRIDE=kvantum
fi
