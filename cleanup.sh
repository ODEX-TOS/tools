#!/bin/bash

NEW_USER=$(cat /etc/passwd | grep "/home" |cut -d: -f1 |head -1)
DISTRO_NAME=""

do_check_internet_connection(){
    ping -c 1 8.8.8.8 >& /dev/null   # ping Google's address
}

do_arch_news_latest_headline(){
    # gets the latest Arch news headline for 'kalu' config file news.conf
    local info=$(mktemp)
    wget -q -T 10 -O $info https://www.archlinux.org/ && \
        { grep 'title="View full article:' $info | sed -e 's|&gt;|>|g' -e 's|^.*">[ ]*||' -e 's|</a>$||' | head -n 1 ; }
    rm -f $info
}

do_config_for_app(){
    # handle configs for apps here; called from distro specific function

    local app="$1"    # name of the app

    case "$app" in
        kalu)
            mkdir -p /etc/skel/.config/kalu
            printf "Last=" >> /etc/skel/.config/kalu/news.conf
            do_arch_news_latest_headline >> /etc/skel/.config/kalu/news.conf
            ;;
        update-mirrorlist)
            test -x /usr/bin/$app && {
                /usr/bin/$app
            }
            ;;
        # add other apps here!
        *)
            ;;
    esac
}

do_common_systemd(){

systemctl enable NetworkManager -f 2>>/tmp/.errlog
systemctl disable multi-user.target 2>>/dev/null
systemctl enable vboxservice 2>>/dev/null
systemctl enable org.cups.cupsd.service 2>>/dev/null
systemctl enable avahi-daemon.service 2>>/dev/null
systemctl disable pacman-init.service choose-mirror.service
systemctl disable systemd-logind

# Journal
sed -i 's/volatile/auto/g' /etc/systemd/journald.conf 2>>/tmp/.errlog

}

do_clean_archiso(){

rm -f /etc/sudoers.d/g_wheel 2>>/tmp/.errlog
rm -f /var/lib/NetworkManager/NetworkManager.state 2>>/tmp/.errlog
sed -i 's/.*pam_wheel\.so/#&/' /etc/pam.d/su 2>>/tmp/.errlog
find /usr/lib/initcpio -name archiso* -type f -exec rm '{}' \;
rm -Rf /etc/systemd/system/{choose-mirror.service,pacman-init.service,etc-pacman.d-gnupg.mount,getty@tty1.service.d}
rm -Rf /etc/systemd/scripts/choose-mirror
rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
rm -f /root/{.automated_script.sh,.zlogin}
rm -f /etc/mkinitcpio-archiso.conf
rm -Rf /etc/initcpio
rm -Rf /etc/udev/rules.d/81-dhcpcd.rules

}

do_vbox(){

# Detects if running in vbox
local xx

lspci | grep -i "virtualbox" >/dev/null
if [[ $? == 0 ]]
    then
        :      
    else
        for xx in virtualbox-guest-utils virtualbox-guest-modules-arch virtualbox-guest-dkms ; do
            test -n "$(pacman -Q $xx 2>/dev/null)" && pacman -Rnsdd $xx --noconfirm
        done
        rm -f /usr/lib/modules-load.d/virtualbox-guest-dkms.conf
fi

}

do_display_manager(){
# no problem if any of them fails
systemctl -f enable gdm || echo "gmd display manager is not present"
systemctl -f enable lightdm || echo "lightdm display manager is not present"
systemctl -f enable sddm || echo "sddm display manager is not present"
pacman -R gnome-software --noconfirm
pacman -Rsc gnome-boxes --noconfirm

}

do_user_setup(){
    cd /home/$NEW_USER
    rm -rf .config
    git clone https://github.com/ODEX-TOS/dotfiles .config
    sed -i 's;/home/zeus;'/home/$NEW_USER';g' /home/$NEW_USER/.config/i3/config
    sed -i 's;/home/zeus;'/home/$NEW_USER';g' /home/$NEW_USER/.config/sway/config_azerty
    sed -i 's;/home/zeus;'/home/$NEW_USER';g' /home/$NEW_USER/.config/sway/config_qwerty
    #setup firefox
    mkdir -p /home/$NEW_USER/.mozilla/firefox/tos.default
    cp /home/$NEW_USER/.config/tos/profiles.ini /home/$NEW_USER/.mozilla/firefox/profiles.ini
    cp -r /home/$NEW_USER/.config/tos/tos-firefox/* /home/$NEW_USER/.mozilla/firefox/tos.default

    yay -Syu --noconfirm zsh
    sudo chsh $NEW_USER -s /bin/zsh
    rm -rf /home/$NEW_USER/.oh-my.zsh
    curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o install.sh
    export RUNZSH=no
    export ZSH=/home/$NEW_USER/.oh-my-zsh
    sh install.sh
    rm install.sh
    rm /home/$NEW_USER/.zshrc /home/$NEW_USER/.vimrc /home/$NEW_USER/.profile

    ln .config/.zshrc /home/$NEW_USER/.zshrc
    ln .config/.profile /home/$NEW_USER/.profile
    ln .config/.vimrc /home/$NEW_USER/.vimrc
    curl -fLo /home/$NEW_USER/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    git clone https://github.com/VundleVim/Vundle.vim.git /home/$NEW_USER/.vim/bundle/Vundle.vim
    ln .config/.Xresources /home/$NEW_USER/.Xresources
    mkdir -p /home/$NEW_USER/.icons/default
    ln .config/index.theme /home/$NEW_USER/.icons/default/index.theme
    git clone https://github.com/ODEX-TOS/zsh-load /home/$NEW_USER/.oh-my-zsh/load
    cd /home/$NEW_USER
    rmdir Pictures
    git clone https://github.com/ODEX-TOS/Pictures Pictures

    git clone https://github.com/zsh-users/zsh-autosuggestions /home/$NEW_USER/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$NEW_USER/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions.git /home/$NEW_USER/.oh-my-zsh/custom/plugins/zsh-completions
    git clone https://github.com/denysdovhan/spaceship-prompt.git /home/$NEW_USER/.oh-my-zsh/custom/themes/spaceship-prompt
    ln -s /home/$NEW_USER/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme /home/$NEW_USER/.oh-my-zsh/custom/themes/spaceship.zsh-theme
    curl https://raw.githubusercontent.com/ODEX-TOS/tools/master/_tos >  /home/$NEW_USER/.oh-my-zsh/custom/plugins/zsh-completions/src/_tos

    if [[ "$(command -v startkde)" ]]; then
        printf "xrdb ~/.Xresources\nexec startkde" >> /home/$NEW_USER/.xinitrc
    else 
        printf "xrdb ~/.Xresources\nexec i3" >> /home/$NEW_USER/.xinitrc
    fi

    mkdir -p /home/$NEW_USER/.vim/colors
    curl https://bitbucket.org/sjl/badwolf/raw/tip/colors/badwolf.vim > /home/$NEW_USER/.vim/colors/badwolf.vim
    #installing vundle
    git clone https://github.com/VundleVim/Vundle.vim.git /home/$NEW_USER/.vim/bundle/Vundle.vim
    #Cloning plugin
    git clone https://github.com/ycm-core/YouCompleteMe.git /home/$NEW_USER/.vim/bundle/YouCompleteMe
    cd ~/.vim/bundle/YouCompleteMe
    python3 install.py --all
    sudo sh -c 'curl https://raw.githubusercontent.com/ODEX-TOS/tos-live/master/toslive/version-edit.txt > /etc/version'


    systemctl enable bluetooth
    systemctl enable sshd
    systemctl enable tlp

    chown -R $NEW_USER:users /home/$NEW_USER

    printf 'GRUB_THEME="/boot/grub/themes/tos/theme.txt"' >> /etc/default/grub
}

do_tos(){

rm -rf /home/$NEW_USER/{.xinitrc,.xsession} 2>>/tmp/.errlog
rm -rf /root/{.xinitrc,.xsession} 2>>/tmp/.errlog
rm -rf /etc/skel/{.xinitrc,.xsession} 2>>/tmp/.errlog
sed -i "/if/,/fi/"'s/^/#/' /home/$NEW_USER/.bash_profile
sed -i "/if/,/fi/"'s/^/#/' /home/$NEW_USER/.zprofile
sed -i "/if/,/fi/"'s/^/#/' /root/.bash_profile
sed -i "/if/,/fi/"'s/^/#/' /root/.zprofile

do_user_setup

do_display_manager

do_check_internet_connection && {
    #do_config_for_app update-mirrorlist
    do_config_for_app kalu
}

chmod 750 /root
}



########################################
########## SCRIPT STARTS HERE ##########
########################################

do_common_systemd
do_clean_archiso
do_tos
rm -rf /usr/bin/installer
rm -rf /usr/bin/cleaner_script.sh
