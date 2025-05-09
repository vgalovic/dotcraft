#!/bin/bash

# Settings
declare -a LIST_OF_WINDOW_TITLES_THAT_PREVENT_LOCKING=(
    "YouTube"
    "Max"
    "Netflix"
)

# Dependencies
AWK=/usr/bin/awk
GREP=/usr/bin/grep
XPROP=/usr/bin/xprop

# Find active window id
get_active_id() {
    $XPROP -root | $AWK '$1 ~ /_NET_ACTIVE_WINDOW/ { print $5 }'
}

# Determine a window's title text by its ID
get_window_title() {
    $XPROP -id $1 | $AWK -F '=' '$1 ~ /_NET_WM_NAME\(UTF8_STRING\)/ { print $2 }'
}

# Determine if a window is fullscreen based on its ID
is_fullscreen() {
    $XPROP -id $1 | $AWK -F '=' '$1 ~ /_NET_WM_STATE\(ATOM\)/ { for (i=2; i<=3; i++) if ($i ~ /FULLSCREEN/) exit 0; exit 1 }'
    return $?
}

# Determine if the locker command should run based on window title or fullscreen
should_lock() {
    id=$(get_active_id)
    title=$(get_window_title $id)

    # First check if the title matches any of the prevent list titles
    for i in "${LIST_OF_WINDOW_TITLES_THAT_PREVENT_LOCKING[@]}"; do
        if [[ "$title" =~ $i ]]; then
            return 1
        fi
    done

    # If not prevented by title, check if the window is fullscreen
    if is_fullscreen $id; then
        return 1
    else
        return 0
    fi
}

# Main script execution
if should_lock; then
    $HOME/.config/i3/lock.sh
fi
