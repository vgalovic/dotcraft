#!/bin/bash

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

install_zsh() {
  if command -v zsh >/dev/null; then
    print_msg "ZSH is already installed."
  else
    print_msg "Installing ZSH..."

    if command -v apt >/dev/null; then
      sudo apt update && sudo apt install -y zsh || { print_error "Failed to install ZSH with apt."; return 1; }
    elif command -v dnf >/dev/null; then
      sudo dnf install -y zsh || { print_error "Failed to install ZSH with dnf."; return 1; }
    elif command -v pacman >/dev/null; then
      sudo pacman -Sy --noconfirm zsh || { print_error "Failed to install ZSH with pacman."; return 1; }
    else
      print_error "Unsupported distribution (no known package manager detected)."
      return 1
    fi
  fi

  print_msg "ZSH installed."

  if prompt_yes_default "Do you want to make ZSH your default shell?"; then
    ZSH_PATH=$(command -v zsh)
    if [ -n "$ZSH_PATH" ]; then
      if [ "$SHELL" != "$ZSH_PATH" ]; then
        sudo chsh -s "$ZSH_PATH" || { print_error "Failed to set ZSH as default shell."; return 1; }
        print_msg "ZSH set as default shell."
      else
        print_msg "ZSH is already your default shell."
      fi
    else
      print_error "ZSH executable not found."
      return 1
    fi
  fi
}

install_fish() {
  if command -v fish >/dev/null; then
    print_msg "Fish Shell is already installed."
  else
    print_msg "Installing Fish Shell..."

    if command -v apt >/dev/null; then
      sudo apt-add-repository -y ppa:fish-shell/release-4 || { print_error "Failed to add Fish's PPA."; return 1; }
      sudo apt update && sudo apt install -y fish || { print_error "Failed to install Fish with apt."; return 1; }
    elif command -v dnf >/dev/null; then
      sudo dnf install -y fish || { print_error "Failed to install Fish with dnf."; return 1; }
    elif command -v pacman >/dev/null; then
      sudo pacman -Sy --noconfirm fish || { print_error "Failed to install Fish with pacman."; return 1; }
    else
      print_error "Unsupported distribution (no known package manager detected)."
      return 1
    fi
  fi

  print_msg "Fish Shell installed."

  if prompt_yes_default "Do you want to make Fish your default shell?"; then
    FISH_PATH=$(command -v fish)
    if [ -n "$FISH_PATH" ]; then
      if [ "$SHELL" != "$FISH_PATH" ]; then
        sudo chsh -s "$FISH_PATH" || { print_error "Failed to set Fish as default shell."; return 1; }
        print_msg "Fish set as default shell."
      else
        print_msg "Fish is already your default shell."
      fi
    else
      print_error "Fish executable not found."
      return 1
    fi
  fi
}

PS3="Choose your shell (or keep bash): "
options=("Fish" "Zsh" "Keep Bash")
select opt in "${options[@]}"; do
  case "$REPLY" in
    1) install_fish; break ;;
    2) install_zsh; break ;;
    3) print_msg "Keeping Bash as default shell."; break ;;
    *) print_error "Invalid option. Please select a number from the list."; ;;
  esac
done
