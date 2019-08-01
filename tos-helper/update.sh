#!/bin/bash

function installyay {
    cd
    git clone https://aur/archlinux.org/yay.git
    cd yay
    makepkg -si
    cd
    rm -rf yay
}

function update {
    printf "${GREEN} Checking all packages and repo's${NC}\n"
    if [[ "$(which yay)" != "/usr/bin/yay" ]]; then
        installyay
    fi

    yay -Syu
    
    if [[ "$(which git)" != "/usr/bin/git" ]]; then
        yay -Syu git
    fi

    if [[ "$(which wal)" != "/usr/bin/wal" ]]; then
        yay -Syu python-pywal
    fi
    
    if [[ ! -d ~/.oh-my-zsh ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        git clone https://github.com/F0xedb/zsh-load.git ~/.oh-my-zsh/load
    fi

    if [[ ! -d ~/bin ]]; then
        git clone https://github.com/F0xedb/helper-scripts.git ~/bin 
    fi


    if [[ ! -f ~/.config/emoji ]]; then
        git clone https://github.com/F0xedb/dotfiles.git ~/.config
    fi

    if [[ ! -d ~/Pictures ]]; then
        mkdir ~/Pictures
        git clone https://github.com/F0xedb/Pictures.git ~/Pictures
    fi

    if [[ "$(which st)" != "/usr/local/bin/st" ]]; then
        cd /tmp
        git clone https://github.com/F0xedb/sucklessterminal.git
        cd sucklessterminal && make && sudo make install       
    fi

    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    if [[ ! -f "$ZSH_CUSTOM/themes/spaceship.zsh-theme" ]]; then
           git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
          ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    fi

    #Finding all firefox profiles and loading in the custom css (it must be enabled in firefox)
    for profile in ~/.mozilla/firefox/*.dev-edition-default; do
            cd $profile
            cp -r ~/.config/.mozilla/firefox/profile/ $profile
            echo $profile
    done

    printf "${RED}If your repo's contain uncommited changes pleas commit them\n git add . && git commit -m \"Data about change\"${NC}\n"
    
    cd ~/bin && git pull origin master
    cd ~/.config && git pull origin master
    cd ~/Pictures && git pull origin master
    cd ~/.oh-my-zsh/load && git pull origin master
    cd

    tospath="$HOME/.oh-my-zsh/custom/plugins/zsh-completions/src/"
    if [[ ! -f "$tospath"_tos ]]; then
            curl https://raw.githubusercontent.com/F0xedb/tos-live/master/_tos -o "$tospath"_tos
    fi
    
    if [[ "$(which chafa)" != "/usr/bin/chafa" ]]; then
        yay -Syu chafa
    fi

    
    if [[ "$(which neofetch)" != "/usr/bin/neofetch" ]]; then
        yay -Syu neofetch
    fi
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