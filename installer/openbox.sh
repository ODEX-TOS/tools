#!/bin/bash
# Important this script will only work with the tos config.
# There should be more download scripts if you wan't this to be compatible with another dotfile repo
source "$framework"

prmpt "Starting the installation for openbox"

packages openbox-patched obconf

ask "Do you want the tos openbox config?" "yes"

if [[ "$result" == "yes" ]]; then
    download "$HOME/.themes/tos/openbox-3" bullet.xbm "https://raw.githubusercontent.com/F0xedb/dotfiles/master/.themes/tos/openbox-3/bullet.xbm" 
    download "$HOME/.themes/tos/openbox-3" close.xbm "https://raw.githubusercontent.com/F0xedb/dotfiles/master/.themes/tos/openbox-3/close.xbm" 
    download "$HOME/.themes/tos/openbox-3" max.xbm "https://raw.githubusercontent.com/F0xedb/dotfiles/master/.themes/tos/openbox-3/max.xbm" 
    download "$HOME/.themes/tos/openbox-3" themerc "https://raw.githubusercontent.com/F0xedb/dotfiles/master/.themes/tos/openbox-3/themerc" 
    prmpt "Themes have been setup"
fi

ask "Do you want openbox as the defaulti window manager?" "yes"
if [[ "$result" == "yes" ]]; then
    echo "exec openbox-session" > "$HOME/.xinitrc"
fi

prmpt "The installation is done!!"
