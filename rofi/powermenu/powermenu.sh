#!/bin/bash

# Rofi power menu with a black-and-white theme

rofi_command="rofi -dmenu -i -p 'Power Menu' -theme ~/.config/rofi/powermenu/powermenu.rasi"

# Options
shutdown="  Shutdown"
reboot="  Reboot"
lock="  Lock"
suspend="⏾  Suspend"
logout="  Logout"

# Display the menu
chosen=$(echo -e "$shutdown\n$reboot\n$lock\n$suspend\n$logout" | $rofi_command)

# Execute the selected command
case $chosen in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$lock")
        betterlockscreen -l || i3lock
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$logout")
        pkill -KILL -u "$USER"
        ;;
esac
