#!/bin/bash

# Take a screenshot
scrot /tmp/screenshot.png

# Blur it (choose ffmpeg OR imagemagick)
ffmpeg -i /tmp/screenshot.png -vf "gblur=sigma=8" -frames:v 1 /tmp/blurred.png -y
# convert /tmp/screenshot.png -blur 0x8 /tmp/blurred.png  # Alternative method

# Lock the screen
i3lock -i /tmp/blurred.png --nofork

# Clean up
rm -f /tmp/screenshot.png /tmp/blurred.png

