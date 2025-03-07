#!/bin/bash

# ============================================
# Desktop Environment and Window Manager Check
# ============================================

# --- Check for Desktop Environments ---
if [ "$DESKTOP_SESSION" = "cinnamon" ] || \
    [ "$DESKTOP_SESSION" = "gnome" ] || \
    [ "$DESKTOP_SESSION" = "kde" ] || \
    [ "$DESKTOP_SESSION" = "mate" ] || \
    [ "$DESKTOP_SESSION" = "xfce" ]; then

    # Use the desktop environment config
    conky -c /home/vgalovic/.config/conky/de.conf &
    exit 0  # Exit after running the DE config

    # --- Check for Window Managers ---
elif [ "$XDG_SESSION_DESKTOP" = "i3" ] || \
    [ "$XDG_SESSION_DESKTOP" = "openbox" ] || \
    [ "$XDG_SESSION_DESKTOP" = "bspwm" ] || \
    [ "$XDG_SESSION_DESKTOP" = "awesome" ] || \
    [ "$XDG_SESSION_DESKTOP" = "hyperland" ] || \
    [ "$XDG_SESSION_DESKTOP" = "dwm" ]; then

    # Use the window manager config
    conky -c /home/vgalovic/.config/conky/wm.conf &
    exit 0  # Exit after running the WM config

fi

