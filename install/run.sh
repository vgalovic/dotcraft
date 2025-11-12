#!/bin/bash

# This script automates the setup of environment tools and applications.
# It will prompt for sudo access if not run with root permissions.

source "$HOME/.dotfiles/install/setup/print_and_log.sh"
echo "Installation log: $(date)" > "$LOG_FILE"

# Ensure SETUP_DIR exists
if [ ! -d "$SETUP_DIR" ]; then
  print_error "The directory $SETUP_DIR does not exist."
  exit 1
fi

pm=""

# Run essential setup scripts without prompting
if command -v apt >/dev/null; then
  pm="apt"
  must_execute_script "setup_apt"
elif command -v dnf >/dev/null; then
  pm="dnf"
  must_execute_script "setup_dnf"
elif command -v pacman >/dev/null; then
  pm="pacman"
  must_execute_script "setup_pacman"
  execute_script "setup_yay"
else
  print_error "Unsupported os!"
  exit 1
fi

must_execute_script "setup_kvantum_papirus"

# Execute setup scripts for install packages tools
for script in setup_rust setup_pipx setup_npm; do
  execute_script "$script"
done

execute_script "setup_flatpak"

if [[ -n "$pm" ]]; then
  echo -e "Choose installation method:"
  echo -e "\t1) $pm (recommended)"
  echo -e "\t2) Homebrew"
  echo -e "\t3) Skip\n"
  read -e -rp "Enter choice [1-3]: " choice

  case "$choice" in
    1)
      must_execute_script "setup_${pm}_apps"
      ;;
    2)
      must_execute_script "setup_brew"
      ;;
    3)
      print_msg "Skipping this part of the setup."
      ;;
    *)
      print_error "Invalid option."
      ;;
  esac
else
  execute_script "setup_brew"
fi

# Execute other setup scripts with user prompts
for script in setup_terminal_and_prompt setup_shell setup_fonts setup_mega_sync setup_latex; do
  execute_script "$script"
done

must_execute_script "setup_stow"

# Helper function for downloading files
download_file() {
  local url="$1"
  local dest="$2"
  curl -fsSL "$url" -o "$dest" || print_error "Failed to download from $url"
}

# Install Zen Browser
if prompt_yes_default "Do you want to install Zen browser?"; then
  if echo "1" | bash <(curl -s https://updates.zen-browser.app/appimage.sh); then
    print_msg "Zen browser installed successfully."
  else
    print_error "Failed to install Zen browser."
  fi
fi

# Install Zed Text Editor
if prompt_yes_default "Do you want to install Zed Tex Editor?"; then
  if curl -fsSL https://zed.dev/install.sh | sh; then
    print_msg "Zed Tex Editor installed successfully."
  else
    print_error "Failed to install Zed Tex Editor."
  fi
fi

# Completion message and reboot prompt
print_msg "Installation complete! Some changes may require a terminal restart to take effect."
if prompt_yes_default "Would you like to reboot now?"; then
  print_msg "Rebooting now..."
  sudo reboot
else
  print_msg "Reboot canceled. Please restart your terminal session for changes to take effect."
fi
