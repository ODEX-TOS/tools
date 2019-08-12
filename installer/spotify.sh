#!/bin/bash

source "$framework"

prmpt "Setting up spotify"

packages spotify spicetify-cli

ask "Do you want to install a custom theme?" "yes"

if [[ "$result" == "yes" ]]; then
    sudo chown "$USER" -R /opt/spotify

    spicetify

    spicetify backup apply enable-devtool

    download "$HOME/.config/spicetify/Themes/green" color.ini "https://raw.githubusercontent.com/WillPower3309/dotfiles/master/.config/spicetify/Themes/custom_theme/color.ini"

    sed -i 's:current_theme    = SpicetifyDefault:current_theme    = green:' "$HOME"/.config/spicetify/config.ini 

    spicetify update restart
fi

prmpt "Spotify is now installed!"
