#!/usr/bin/env bash

# ============================================================
# Universal terminal startup script
# ============================================================

# Prevent running multiple times in the same shell
if [ -n "$TERMINAL_STARTUP_DONE" ]; then
  return 0 2>/dev/null || exit 0
fi

export TERMINAL_STARTUP_DONE=1

# Run once-per-terminal startup tasks
fastfetch -c ~/.config/fastfetch/minimal_fetch.jsonc && echo ''

# Replace current shell with interactive login shell
if [ -z "$KITTY_WINDOW_ID" ]; then
  exec "${SHELL:-/bin/bash}" -i
fi
