#!/bin/sh

# Set TMP_DIR to the user's runtime directory (a RAM-backed temporary folder)
TMP_DIR="/run/user/$(id -u)"

# Take a screenshot
scrot "$TMP_DIR/screenshot.png"

# Blur it (choose ffmpeg OR imagemagick)
ffmpeg -i "$TMP_DIR/screenshot.png" -vf "gblur=sigma=8" -frames:v 1 -update 1 "$TMP_DIR/blurred.png" -y
# convert "$TMP_DIR/screenshot.png" -blur 0x8 "$TMP_DIR/blurred.png"

# Lock the screen with blurred background
i3lock -i "$TMP_DIR/blurred.png" \
    --nofork \
    --color=24273a  \
    --ignore-empty-password \
    --show-failed-attempts \


# Clean up
rm -f "$TMP_DIR/screenshot.png" "$TMP_DIR/blurred.png"
