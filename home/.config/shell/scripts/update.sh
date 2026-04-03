#!/bin/bash
# ==========================================================
# System Update Script
# ----------------------------------------------------------
# Updates available package managers:
#   - apt (Debian / Ubuntu)
#   - dnf (Fedora / RHEL – offline updates)
#   - flatpak
#   - snap
#   - homebrew
#   - cargo
#   - pipx
#
# If Fedora offline updates require a reboot, the user
# is prompted with a colored confirmation.
# ==========================================================

set -euo pipefail

# ----------------------------------------------------------
# Helper: Print a yellow prompt/message (used for questions)
# NOTE: Intended for use inside command substitution:
#       read -rp "$(ask "Question")" var
# ----------------------------------------------------------
ask() {
  echo -e "\e[33m$1\e[0m"
}

# ----------------------------------------------------------
# Helper: Print a green, bold status/info message
# Used for progress and success notifications
# ----------------------------------------------------------
print_msg() {
  echo -e "\e[1;32m$1\e[0m"
}

# ==========================================================
# APT (Debian / Ubuntu)
# ==========================================================
if command -v apt >/dev/null 2>&1; then
  print_msg "Updating apt packages..."
  sudo apt update
  sudo apt upgrade -y
  print_msg "apt packages updated."
fi

# ==========================================================
# DNF (Fedora / RHEL) — Offline Updates
# ==========================================================
if command -v dnf >/dev/null 2>&1; then
  print_msg "Downloading Fedora offline updates..."
  sudo dnf offline-upgrade download -y
  print_msg "Offline updates downloaded."
fi

# ==========================================================
# ZYPPER (openSUESE)
# ==========================================================
if command -v zypper >/dev/null 2>&1; then
  print_msg "Updating zypper packages..."
  sudo zypper refresh
  sudo zypper dup
  print_msg "zypper packages updated."
fi

# ==========================================================
# Flatpak
# ==========================================================
if command -v flatpak >/dev/null 2>&1; then
  print_msg "Updating Flatpak packages..."
  flatpak update -y
  print_msg "Flatpak packages updated."
fi

# ==========================================================
# Snap
# ==========================================================
if command -v snap >/dev/null 2>&1; then
  print_msg "Updating Snap packages..."
  sudo snap refresh
  print_msg "Snap packages updated."
fi

# ==========================================================
# Homebrew (Linux / macOS)
# ==========================================================
if command -v brew >/dev/null 2>&1; then
  print_msg "Updating Homebrew packages..."
  brew update
  brew upgrade
  print_msg "Homebrew packages updated."
fi

# ==========================================================
# Cargo (Rust)
# ==========================================================
if command -v cargo-install-update >/dev/null 2>&1; then
  print_msg "Updating Cargo-installed packages..."
  cargo install-update --all
  print_msg "Cargo packages updated."
fi

# ==========================================================
# Pipx (Python CLI tools)
# ==========================================================
if command -v pipx >/dev/null 2>&1; then
  print_msg "Updating Pipx packages..."
  pipx upgrade-all
  print_msg "Pipx packages updated."
fi

# ==========================================================
# Completion Message
# ==========================================================
print_msg "All updates completed."

# ==========================================================
# Fedora Offline Reboot Prompt
# ----------------------------------------------------------
# Check whether a reboot is required to apply offline
# updates, and prompt the user in yellow if so.
# ==========================================================
if command -v dnf >/dev/null 2>&1 \
  && grep -qi "offline reboot" \
  < <(sudo dnf offline-upgrade status 2>/dev/null | tee /dev/null); then

  read -rp "$(ask "System restart required to apply updates. Reboot now? (Y/n) ")" choice

  if [[ -z "$choice" || "${choice,,}" == "y" ]]; then
    sudo dnf offline-upgrade reboot -y
  fi
fi
