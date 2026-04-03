#!/bin/bash
set -euo pipefail

# ============================================================
# Dotlink script — links dotfiles safely with in-place backups
# ============================================================

DOTFILES_HOME="$HOME/.dotfiles/home"
HOME_DIR="$HOME"
CONFIG_DIR="$HOME/.config"
BACKUP_SUFFIX=".dotlink_bak"

source "$HOME/.dotfiles/install/setup/print_and_log.sh"

# ------------------------------------------------------------
# Argument parsing
# ------------------------------------------------------------
MODE="apply"
ARG="${1:-}"

case "$ARG" in
  audit)
    MODE="audit"
    ;;
  clean)
    MODE="clean"
    ;;
  apply|"")
    MODE="apply"
    ;;
  *)
    print_error "Unknown command: $ARG (use: audit | apply | clean)"
    exit 1
    ;;
esac

# ------------------------------------------------------------
# Sanity checks
# ------------------------------------------------------------
[[ -d "$DOTFILES_HOME" ]] || { print_error "Dotfiles home not found: $DOTFILES_HOME"; exit 1; }
mkdir -p "$CONFIG_DIR"

# ------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------
backup_and_link() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  # Skip foreign symlinks pointing elsewhere
  if [[ -L "$dst" && "$(readlink -f "$dst")" != "$(readlink -f "$src")" ]]; then
    print_error "Foreign symlink detected, skipping: $dst"
    return
  fi

  # Backup existing file/dir/symlink
  if [[ -e "$dst" || -L "$dst" ]]; then
    mv "$dst" "$dst$BACKUP_SUFFIX"
    print_msg "Backed up: $dst → $dst$BACKUP_SUFFIX"
  fi

  # Create symlink
  ln -sfn "$src" "$dst"
  print_msg "Linked: $dst → $src"
}

audit_item() {
  if [[ $# -lt 2 ]]; then
    print_error "audit_item requires 2 arguments, got $#"
    return 1
  fi

  local src="${1:?missing src}"
  local dst="${2:?missing dst}"

  if [[ ! -e "$dst" ]]; then
    echo "[MISSING] $dst"
    return
  fi

  if [[ -L "$dst" ]]; then
    local dst_real src_real
    dst_real="$(realpath -m "$dst")"
    src_real="$(realpath -m "$src")"
    if [[ "$dst_real" != "$src_real" ]]; then
      echo "[WRONG LINK] $dst → $(readlink "$dst")"
    fi
  else
    echo "[BLOCKED] $dst (real file/dir)"
  fi
}

remove_old_backups() {
  print_msg "Removing backup files with suffix $BACKUP_SUFFIX..."

  # Home directory backups
  find "$HOME" -maxdepth 1 -name "*$BACKUP_SUFFIX" -exec rm -rf {} \; -exec echo "Removed {}" \;

  # Config directory backups
  find "$CONFIG_DIR" -mindepth 1 -maxdepth 1 -name "*$BACKUP_SUFFIX" -exec rm -rf {} \; -exec echo "Removed {}" \;

  print_msg "All $BACKUP_SUFFIX backups removed."
}

cleanup_orphans() {
  print_msg "Cleaning orphaned dotfile symlinks..."

  # Only top-level dotfiles in $HOME
  find "$HOME" -maxdepth 1 -type l | while IFS= read -r link; do
    [[ -z "$link" ]] && continue
    target="$(readlink "$link")" || continue
    [[ "$target" == "$DOTFILES_HOME"* ]] || continue
    if [[ ! -e "$target" ]]; then
      rm -f "$link" || true
      print_msg "Removed orphan: $link"
    fi
  done

  # Only children of $HOME/.config
  if [[ -d "$CONFIG_DIR" ]]; then
    find "$CONFIG_DIR" -mindepth 1 -maxdepth 1 -type l | while IFS= read -r link; do
      [[ -z "$link" ]] && continue
      target="$(readlink "$link")" || continue
      [[ "$target" == "$DOTFILES_HOME"* ]] || continue
      if [[ ! -e "$target" ]]; then
        rm -f "$link" || true
        print_msg "Removed orphan: $link"
      fi
    done
  fi

  print_msg "Orphan cleanup completed."
}

# ------------------------------------------------------------
# Audit mode
# ------------------------------------------------------------
audit_dotfiles() {
  print_msg "Audit mode"

  # Home files, excluding .config
  find "$DOTFILES_HOME" -mindepth 1 -maxdepth 1 \
    ! -name '.config' \
    ! -name '.git' \
    | while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    rel="${item#$DOTFILES_HOME/}"
    audit_item "$item" "$HOME_DIR/$rel"
  done

  # Config children only
  if [[ -d "$DOTFILES_HOME/.config" ]]; then
    find "$DOTFILES_HOME/.config" -mindepth 1 -maxdepth 1 | while IFS= read -r item; do
      [[ -z "$item" ]] && continue
      name="$(basename "$item")"
      audit_item "$item" "$CONFIG_DIR/$name"
    done
  fi

  print_msg "Audit complete."
}

# ------------------------------------------------------------
# Main linking logic
# ------------------------------------------------------------
link_dotfiles() {
  print_msg "Linking dotfiles"

  # Home files (excluding .config)
  find "$DOTFILES_HOME" -mindepth 1 -maxdepth 1 \
    ! -name '.config' \
    ! -name '.git' \
    | while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    rel="${item#$DOTFILES_HOME/}"
    backup_and_link "$item" "$HOME_DIR/$rel"
  done

  # Config children only
  if [[ -d "$DOTFILES_HOME/.config" ]]; then
    find "$DOTFILES_HOME/.config" -mindepth 1 -maxdepth 1 | while IFS= read -r item; do
      [[ -z "$item" ]] && continue
      name="$(basename "$item")"
      backup_and_link "$item" "$CONFIG_DIR/$name"
    done
  fi

  print_msg "Dotfiles linked successfully."

  # --- Automatically audit after linking ---
  print_msg "Running audit to verify links..."
  audit_dotfiles
}

# ------------------------------------------------------------
# Run script
# ------------------------------------------------------------
case "$MODE" in
  audit)
    audit_dotfiles
    ;;
  clean)
    cleanup_orphans
    remove_old_backups
    ;;
  apply)
    link_dotfiles

    if prompt_yes_default "Remove orphaned dotfile symlinks? "; then
      cleanup_orphans
    fi

    if prompt_yes_default "Remove backup files with suffix $BACKUP_SUFFIX? "; then
      remove_old_backups
    fi

    print_msg "Done. Restart your shell to apply changes."
    ;;
esac

