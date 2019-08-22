#!/bin/bash
# This source statement must be present at the top of this file
source "$framework"

prmpt "Installing minimal plasma desktop"

packages plasma-dekstop

ask "Do you want wayland support?" "yes"

if [[ "$result" == "yes" ]]; then
    packages plasma-wayland-session

    ask "Do you want wayland as the default plasma compositor?" "yes"
    wayland="$result"

fi

ask "Do you want KDE applications?" "yes"

if [[ "$result" == "yes" ]]; then
    packages kde-applications
fi

ask "Do you want kde as the default DE during boot" "yes"

if [[ "$result" == "yes" ]]; then
    if [[ "$wayland" == "yes" ]]; then
        printf 'if [[ "%s(tty)" == "/dev/tty1" ]]; then \n\tXDG_SESSION_TYPE=wayland dbus-run-session startplasmacompositor\nfi\n' "$" >> .profile
    else
        echo "exec startkde" > .xinitrc
    fi
fi

prmpt "The installation is done!!"
