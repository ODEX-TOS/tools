#!/bin/bash

# MIT License
# 
# Copyright (c) 2019 Meyers Tom
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# Important this script will only work with the tos config.
# There should be more download scripts if you wan't this to be compatible with another dotfile repo
source "$framework"

prmpt "Starting the installation for openbox"

packages openbox-patched obconf

ask "Do you want the tos openbox config?" "yes"

if [[ "$result" == "yes" ]]; then
    download "$HOME/.themes/tos/openbox-3" bullet.xbm "https://raw.githubusercontent.com/ODEX-TOS/dotfiles/master/.themes/tos/openbox-3/bullet.xbm" 
    download "$HOME/.themes/tos/openbox-3" close.xbm "https://raw.githubusercontent.com/ODEX-TOS/dotfiles/master/.themes/tos/openbox-3/close.xbm" 
    download "$HOME/.themes/tos/openbox-3" max.xbm "https://raw.githubusercontent.com/ODEX-TOS/dotfiles/master/.themes/tos/openbox-3/max.xbm" 
    download "$HOME/.themes/tos/openbox-3" themerc "https://raw.githubusercontent.com/ODEX-TOS/dotfiles/master/.themes/tos/openbox-3/themerc" 
    prmpt "Themes have been setup"
fi

ask "Do you want openbox as the default window manager?" "yes"
if [[ "$result" == "yes" ]]; then
    echo "exec openbox-session" > "$HOME/.xinitrc"
fi

prmpt "The installation is done!!"

