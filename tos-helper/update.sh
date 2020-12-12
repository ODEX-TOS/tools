#!/usr/bin/env bash

# MIT License
# 
# Copyright (c) 2020 Tom Meyers
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

# shellcheck disable=SC2059

function installyay {
    cd || exit 1
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si
    cd || exit 1
    rm -rf yay
}

function update {
    printf "${GREEN} Checking all packages and repo's${NC}\n"
    if [[ ! "$(command -v yay)" ]]; then
        installyay
    fi

    yay -Syu
    
    if [[ ! $(command -v git) ]]; then
        yay -Syu git
    fi

    if [[ ! $(command -v wal) ]]; then
        yay -Syu python-pywal
    fi
    
    if [[ ! -d ~/.oh-my-zsh ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        git clone https://github.com/ODEX-TOS/zsh-load.git ~/.oh-my-zsh/load
    fi

    if [[ ! -d ~/bin ]]; then
        git clone https://github.com/ODEX-TOS/tools.git ~/bin 
    fi


    if [[ ! -f ~/.config/emoji ]]; then
        git clone https://github.com/ODEX-TOS/dotfiles.git ~/.config
    fi

    if [[ ! -d ~/Pictures ]]; then
        mkdir ~/Pictures
        git clone https://github.com/ODEX-TOS/Pictures.git ~/Pictures
    fi

    if [[ "$(command -v st)" ]]; then
            yay -Syu st-tos
    fi

    if [[ "$(command -v i3)" ]]; then
            yay -Syu i3-gaps-tos
    fi

    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    if [[ ! -f "$ZSH_CUSTOM/themes/spaceship.zsh-theme" ]]; then
           git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
          ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    fi

    #Finding all firefox profiles and loading in the custom css (it must be enabled in firefox)
    for profile in ~/.mozilla/firefox/tos.*; do
            cd "$profile" || exit 1
            cp -r ~/.config/.mozilla/firefox/profile/ "$profile"
            echo "$profile" || exit 1 
    done

    printf "${RED}If your repo's contain uncommited changes pleas commit them\n git add . && git commit -m \"Data about change\"${NC}\n"
    
    cd ~/bin && git pull origin master || exit 1
    cd ~/.config && git pull origin master || exit 1
    cd ~/Pictures && git pull origin master || exit 1
    cd ~/.oh-my-zsh/load && git pull origin master || exit 1
    cd || exit 1

    tospath="$HOME/.oh-my-zsh/custom/plugins/zsh-completions/src/"
    if [[ ! -f "$tospath"_tos ]]; then
            curl https://raw.githubusercontent.com/ODEX-TOS/tos-live/master/_tos -o "$tospath"_tos
    fi
    
    if [[ ! "$(command -v chafa)" ]]; then
        yay -Syu chafa
    fi

    
    if [[ ! "$(command -v neofetch)" ]]; then
        yay -Syu neofetch
    fi
    sudo sh -c 'curl https://raw.githubusercontent.com/ODEX-TOS/tos-live/master/toslive/version-edit.txt > /etc/version'
}

function repair {
    yay -Sc
    rankmirror
    yay -Syyu
    tos -u
}

case "$1" in
    "-u"|"--update")
        printf "${RED} This way of updating is deprecated.${NC}\n"
		printf "${RED} Use ${GREEN}tos -Syu${RED} to update to the latest version${NC}\n"
        printf "${RED} If that doesn't work use ${GREEN}system-updater${RED}${NC}\n"
		exit 1
        update
    ;;
    "-rs"|"--repair-system")
        repair
    ;;
esac

