# ~/.zprofile

# Source the universal profile file if it exists
# This ensures that all general environment variables and setup from .profile are applied in Zsh login sessions.
if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

# Source Zsh-specific configuration file if it exists
# This allows Zsh-specific aliases, functions, and settings to be managed in .zshrc.
if [ -f "$HOME/.zshrc" ]; then
    . "$HOME/.zshrc"
fi
