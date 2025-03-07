#!/usr/bin/env bash

# CMDs
lastlogin="$(last "$USER" | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7)"
uptime="$(uptime -p | sed -e 's/up //g')"
host="$(hostname)"

# Options
hibernate=''
shutdown='⏻'
reboot=''
lock=''
suspend=''
logout=''
yes='✔'
no='✘'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "$USER@$host" \
        -mesg " Last Login: $lastlogin |  Uptime: $uptime" \
        -theme $HOME/.config/rofi/powermenu/powermenu.rasi
}

# Confirmation CMD with two columns
confirm_cmd() {
    rofi -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you sure?' \
        -theme $HOME/.config/rofi/powermenu/powermenu.rasi \
        -theme-str 'listview {columns: 2; lines: 1;}'  # This creates two columns
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$lock\n$suspend\n$logout\n$hibernate\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        case $1 in
            --shutdown)
                systemctl poweroff
                ;;
            --reboot)
                systemctl reboot
                ;;
            --hibernate)
                systemctl hibernate
                ;;
            --suspend)
                mpc -q pause
                amixer set Master mute
                systemctl suspend
                ;;
            --logout)
                case "$DESKTOP_SESSION" in
                    openbox)
                        openbox --exit
                        ;;
                    bspwm)
                        bspc quit
                        ;;
                    i3)
                        i3-msg exit
                        ;;
                    plasma)
                        qdbus org.kde.ksmserver /KSMServer logout 0 0 0
                        ;;
                esac
                ;;
        esac
    else
        exit 0
    fi
}

# Actions
chosen="$(run_rofi)"
case "$chosen" in
    "$shutdown")
        run_cmd --shutdown
        ;;
    "$reboot")
        run_cmd --reboot
        ;;
    "$hibernate")
        run_cmd --hibernate
        ;;
    "$lock")
        if [[ -x '/usr/bin/betterlockscreen' ]]; then
            betterlockscreen -l
        elif [[ -x '/usr/bin/i3lock' ]]; then
            ~/.config/i3/lock.sh
        fi
        ;;
    "$suspend")
        run_cmd --suspend
        ;;
    "$logout")
        run_cmd --logout
        ;;
esac

