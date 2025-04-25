#!/bin/bash

# Get the currently focused window
focused_win=$(xdotool getwindowfocus)

# Check if the window is fullscreen
is_fullscreen=$(xprop -id "$focused_win" | grep -q '_NET_WM_STATE_FULLSCREEN' && echo 1 || echo 0)

# Check if media is playing
is_playing=$(playerctl status 2>/dev/null | grep -q 'Playing' && echo 1 || echo 0)

# Suspend lock **only** if BOTH fullscreen and video playing
if [[ "$is_fullscreen" -eq 1 && "$is_playing" -eq 1 ]]; then
  # Likely watching a video in fullscreen → skip lock
  exit 0
fi

# Take a screenshot
scrot /tmp/screenshot.png

# Blur it (choose ffmpeg OR imagemagick)
ffmpeg -i /tmp/screenshot.png -vf "gblur=sigma=8" -frames:v 1 -update 1 /tmp/blurred.png -y
# convert /tmp/screenshot.png -blur 0x8 /tmp/blurred.png  # Alternative method

# Lock the screen with blurred background
i3lock -i /tmp/blurred.png --nofork

# Clean up
rm -f /tmp/screenshot.png /tmp/blurred.png

