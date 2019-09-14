#!/bin/bash

# find all touchpads and enable Tapping if it has that functionality. This is for xorg based window managers
function xorg {
    for pad in $(xinput list | grep Touchpad | awk '{print $6}' | awk -F= '{print $2}'); do
        for prop in $(xinput list-props "$pad" | grep "Tapping Enabled" | awk -F\( '{print $2}' | awk -F\) '{print $1}'); do
            xinput set-prop "$pad" "$prop" 1 &>/dev/null 
        done
    done
}


# to the same as the xorg variant but for sway (this only works for sway)
function wayland {
    id=$(swaymsg -t get_inputs | grep -E 'identifier.*Touchpad' | awk -F\" '{print $4}')
    swaymsg input "$id" tap enabled
}


sleep 5

display=$(pgrep --list-name sway | awk '$2 ~ /^sway$/{print $2}')
echo "$display"
if [[ "$display" == "sway" ]]; then
    wayland
else
    xorg
fi
