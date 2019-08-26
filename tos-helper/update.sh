#!/bin/bash

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
        update
    ;;
    "-rs"|"--repair-system")
        repair
    ;;
esac
