#!/bin/bash

# Kill existing Polybar instances
killall -q polybar

# Launch Polybar for each monitor
if command -v xrandr > /dev/null; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload toph &
    done
else
    polybar --reload toph &
fi

