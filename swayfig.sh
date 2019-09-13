#!/bin/bash


language=$(cat /etc/vconsole.conf | cut -d= -f2)

if [[ "$language" =~ "be" || "$language" =~ "fr" ]]; then
        cp "$HOME"/.config/sway/config_azerty "$HOME"/.config/sway/config
else 
        cp "$HOME"/.config/sway/config_qwerty "$HOME"/.config/sway/config
fi
