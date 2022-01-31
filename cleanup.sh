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

NEW_USER=$(grep "/home" "/etc/passwd" |cut -d: -f1 |head -1)

do_check_internet_connection(){
    ping -c 1 8.8.8.8 >& /dev/null   # ping Google's address
}

do_common_systemd(){

systemctl enable NetworkManager -f 2>/tmp/.errlog
systemctl disable multi-user.target 2>/dev/null
systemctl enable vboxservice 2>/dev/null
systemctl enable org.cups.cupsd.service 2>/dev/null
systemctl enable avahi-daemon.service 2>/dev/null
systemctl enable apparmor.service 2>/dev/null
systemctl disable pacman-init.service choose-mirror.service
systemctl disable systemd-logind
lsblk --discard | awk 'NR!=1&&$3!="0B"&&$4!="0B"{print $3, $4}' | grep -qE '[0-9]*[TGMKB]' && systemctl enable fstrim.timer
systemctl enable --now pkgstats.timer
systemctl enable linux-modules-cleanup

# Journal
sed -i 's/volatile/auto/g' /etc/systemd/journald.conf 2>>/tmp/.errlog

}

do_logind_suspend_state() {
    # hibernate is enabled on the system
    if grep -q "resume=UUID" /etc/default/grub ; then
    cat <<EOF | tee /etc/systemd/logind.conf.d/hibernate.conf
#
# SPDX-License-Identifier: GPL-3.0-or-later

[Login]
HandleSuspendKey=suspend
HandleHibernateKey=hibernate
HandleLidSwitch=suspend-then-hibernate

EOF
    else
        cat <<EOF | tee /etc/systemd/logind.conf.d/lock.conf
#
# SPDX-License-Identifier: GPL-3.0-or-later

[Login]
HandleSuspendKey=ignore
HandleHibernateKey=ignore
HandleLidSwitch=lock

EOF
    fi
    
    # make sure that the systemd logind doesn't block lid events (This is only used in the live iso)
    if [[ -f "/etc/systemd/logind.conf.d/do-not-suspend.conf" ]]; then
        rm "/etc/systemd/logind.conf.d/do-not-suspend.conf"
    fi
}

do_clean_archiso(){

rm -f /etc/sudoers.d/g_wheel 2>/tmp/.errlog
rm -f /var/lib/NetworkManager/NetworkManager.state 2>/tmp/.errlog
sed -i 's/.*pam_wheel\.so/#&/' /etc/pam.d/su 2>/tmp/.errlog
find /usr/lib/initcpio -name 'archiso*' -type f -exec rm '{}' \;
rm -Rf /etc/systemd/system/{choose-mirror.service,pacman-init.service,etc-pacman.d-gnupg.mount,getty@tty1.service.d}
rm -Rf /etc/systemd/scripts/choose-mirror
rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
rm -f /root/{.automated_script.sh,.zlogin}
rm -f /etc/mkinitcpio-archiso.conf
rm -Rf /etc/initcpio
rm -Rf /etc/udev/rules.d/81-dhcpcd.rules

}

do_display_manager(){
# no problem if any of them fails
systemctl -f enable gdm || echo "gmd display manager is not present"
systemctl -f enable sddm || echo "sddm display manager is not present"
systemctl -f enable lightdm || echo "lightdm display manager is not present"
pacman -R gnome-software --noconfirm
pacman -Rsc gnome-boxes --noconfirm

}

do_user_setup(){
    # shellcheck disable=SC2164
    cd /home/"$NEW_USER"
    if [[ -d .config/awesome ]]; then
        rm -rf .config/awesome
    fi

    yay -Syu --noconfirm zsh
    sudo chsh "$NEW_USER" -s /bin/zsh
    curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o install.sh
    export RUNZSH=no
    export ZSH="/home/$NEW_USER/.oh-my-zsh"
    rm -rf "/home/$NEW_USER/.oh-my.zsh"
    sh install.sh
    rm install.sh
    rm "/home/$NEW_USER/.zshrc" "/home/$NEW_USER/.vimrc" "/home/$NEW_USER/.profile"

    ln .config/.zshrc "/home/$NEW_USER/.zshrc"
    ln .config/.profile "/home/$NEW_USER/.profile"

    ln .config/.Xresources "/home/$NEW_USER/.Xresources"
    mkdir -p "/home/$NEW_USER/.icons/default"
    ln .config/index.theme "/home/$NEW_USER/.icons/default/index.theme"
    git clone https://github.com/ODEX-TOS/zsh-load "/home/$NEW_USER/.oh-my-zsh/load"
    # shellcheck disable=SC2164
    cd /home/"$NEW_USER"
    rm -rf Pictures
    git clone https://github.com/ODEX-TOS/Pictures Pictures
    
    rm -rf Pictures/{.git,.gitignore,.github}

    git clone https://github.com/zsh-users/zsh-autosuggestions /home/"$NEW_USER"/.oh-my-zsh/custom/plugins/zsh-autosuggestions

    git clone https://github.com/marlonrichert/fast-syntax-highlighting.git /home/"$NEW_USER"/.oh-my-zsh/custom/plugins/fast-syntax-highlighting

    git clone https://github.com/zsh-users/zsh-completions.git /home/"$NEW_USER"/.oh-my-zsh/custom/plugins/zsh-completions
    git clone https://github.com/marlonrichert/zsh-autocomplete.git /home/"$NEW_USER"/.oh-my-zsh/custom/plugins/zsh-autocomplete

    git clone https://github.com/denysdovhan/spaceship-prompt.git /home/"$NEW_USER"/.oh-my-zsh/custom/themes/spaceship-prompt
    ln -s "/home/$NEW_USER/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" /home/"$NEW_USER"/.oh-my-zsh/custom/themes/spaceship.zsh-theme
    curl https://raw.githubusercontent.com/ODEX-TOS/tools/master/_tos >  /home/"$NEW_USER"/.oh-my-zsh/custom/plugins/zsh-completions/src/_tos

    sudo sh -c 'curl https://raw.githubusercontent.com/ODEX-TOS/tos-live/master/toslive/version-edit.txt > /etc/version'


    systemctl enable bluetooth
    systemctl enable sshd
    systemctl enable tlp

    mkdir -p "/home/$NEW_USER/"{Desktop,Documents,Videos}
    chown -R "$NEW_USER:users" "/home/$NEW_USER"

    printf 'GRUB_THEME="/boot/grub/themes/tos/theme.txt"' >> /etc/default/grub
    # set the lightdm theme to the tos theme
    sed -i 's:#greeter-session=.*$:greeter-session=lightdm-webkit2-greeter:' /etc/lightdm/lightdm.conf

    printf "on\ntime=1800\nfull=false\n/usr/share/backgrounds/tos/default.jpg" > "/home/$NEW_USER/.config/tos/theme"

    # set tde as the default launcher for lightdm (only if it exists)
    if [[ "$(command -v tde)" ]]; then
        sed -i 's:#user-session=default:user-session=tde:' /etc/lightdm/lightdm.conf
        mkdir -p /var/cache/lightdm/dmrc
        printf "[Desktop]\nSession=tde" > /var/cache/lightdm/dmrc/"$NEW_USER".dmrc
        sed -i 's/webkit_theme.*/webkit_theme = tde/g' /etc/lightdm/lightdm-webkit2-greeter.conf
        if [[ -f "/home/$NEW_USER/.config/awesome" ]]; then
            sed -i 's:backend = "xrender";::' /home/"$NEW_USER"/.config/awesome/configuration/compton.conf
        fi

        if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iqE "(paravirtual|QEMU|QXL|virtualbox)"; then
            echo "Detected that we are in a virtualized environment, not using blur"
            sed -i 's:vsync = true;::' /etc/xdg/tde/configuration/compton.conf
            sed -i 's:vsync = true;::' /etc/xdg/tde/configuration/picom.conf
        else
            sed -i 's:backend = "xrender";::' /etc/xdg/tde/configuration/compton.conf
            sed -i 's:backend = "xrender";:backend = "glx";:' /etc/xdg/tde/configuration/picom.conf
            sed -i -e "s/blur-background-frame = false/blur-background-frame = true/g" /etc/xdg/tde/configuration/compton.conf # enable blur after installation
            sed -i -e "s/blur-background-frame = false/blur-background-frame = true/g" /etc/xdg/tde/configuration/picom.conf # enable blur after installation
        fi
        
        cp /etc/xdg/tde/configuration/picom.conf /home/"$NEW_USER"/.config/picom.conf
    fi
}


# This funciton sets up your NVIDIA gpu driver, including extra features such as hardware encoding/decoding
# vulkan support (if applicable), 32bit support and more
do_amd_driver(){
    # install video driver, mesa, 32bit support and hardware encoding/decoding
    pacman -Syu xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver

    # TODO: implement AMD Dynamic Switchable Graphics for laptops
}

# This funciton sets up your NVIDIA gpu driver, including extra features such as hardware encoding/decoding
# vulkan support (if applicable), 32bit support and more
do_intel_driver(){
    pacman -Syu mesa lib32-mesa vulkan-intel
}

# This funciton sets up your NVIDIA gpu driver, including extra features such as hardware encoding/decoding
# vulkan support (if applicable), 32bit support and more
do_nvidia_driver(){
    # install the nvidia driver, 32bit support and
    pacman -Syu nvidia-dkms lib32-nvidia-utils

    # TODO: implement NVIDIA Optimus for laptops
}

# This function detects the driver of your system and sets it up
do_gpu_driver(){
    if [[ ! "$(command -v lspci)" ]]; then
        pacman -Syu pciutils
    fi

    if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq "AMD"; then
        do_amd_driver
    fi

    if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq "INTEL"; then
        do_intel_driver
    fi

    if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq "NVIDIA"; then
        do_nvidia_driver
    fi

}


do_reflector() {
    reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
    systemctl enable reflector.timer
}

do_tos(){

    rm -rf "/home/$NEW_USER/"{.xinitrc,.xsession} 2>/tmp/.errlog
    rm -rf /root/{.xinitrc,.xsession} 2>/tmp/.errlog
    rm -rf /etc/skel/{.xinitrc,.xsession} 2>/tmp/.errlog
    sed -i "/if/,/fi/"'s/^/#/' "/home/$NEW_USER/.bash_profile"
    sed -i "/if/,/fi/"'s/^/#/' "/home/$NEW_USER/.zprofile"
    sed -i "/if/,/fi/"'s/^/#/' /root/.bash_profile
    sed -i "/if/,/fi/"'s/^/#/' /root/.zprofile

    if [[ -d "/home/$NEW_USER/.config/awesome" ]]; then
        rm -rf "/home/$NEW_USER/.config/awesome"
    fi

    do_user_setup

    do_display_manager

    do_check_internet_connection && {
        do_reflector
    }

    chmod 750 /root

    do_gpu_driver
}

# this generates the rescue image and adds it to grub
do_rescue() {
    # first try to detect the iso mountpoint (this is done by searching for mounted iso's with a TOS label)
    # There should only be one (unless a recovery partition already exists, then this might be the recovery partition, in that case we shouldn't continue
    local iso_mount
    iso_mount="$(blkid | grep 'TYPE="iso9660"' | grep -E 'LABEL="TOS_[0-9]+"' | tail -n1 | awk -F: '{print $1}')"
    
    # now we try to detect the rescue partition
    local rescue_partition_UUID
    rescue_partition_UUID="$(grep "/rescue" /etc/fstab | grep -o 'UUID=[0-9a-zA-Z-]*' | cut -d"=" -f2)"


    # if non of those exist then abort
    if [[ "$rescue_partition_UUID" == "" || "$iso_mount" == "" ]]; then
        return
    # in the case that we 'think' that the iso_mount is the rescue_partition (then we abort since there is already a recovery partition)
    elif [[ "$rescue_partition_UUID" == "$iso_mount" ]]; then
        return
    fi
    # now we can dd the iso to our rescue image
    dd status=progress if="$iso_mount" of="/rescue/rescue.iso" bs=10M

    local CMD_LINE
    # we want to find all the parameters in the kernel command line for tos.*=
    # e.g. tos.key,tos/loadkeys, ...
    CMD_LINE="$(grep -Eo 'tos.\S+=\S+' /proc/cmdline | tr '\n' ' ')"

    # we also want cow_spacesize
    CMD_LINE="$CMD_LINE $(grep -Eo 'cow_spacesize=\S+' /proc/cmdline | tr '\n' ' ')"

    # nvidia
    CMD_LINE="$CMD_LINE $(grep -Eo 'nvidia\S*=\S+' /proc/cmdline | tr '\n' ' ')"

    # nomodeset
    CMD_LINE="$CMD_LINE $(grep -Eo 'nomodeset\S*=\S+' /proc/cmdline | tr '\n' ' ')"

    # virtual terminal settings
    CMD_LINE="$CMD_LINE $(grep -Eo 'vt.\S+=\S+' /proc/cmdline | tr '\n' ' ')"



    # lastly we add the menuentry to grub
    cat <<EOF >> /etc/grub.d/40_custom

menuentry "TOS GNU/Linux Rescue system" {
    load_video
    insmod gzio
    insmod part_gpt
    insmod ext2
    search --no-floppy --fs-uuid --set=root $rescue_partition_UUID
    loopback loop /rescue.iso
    linux (loop)/tos/boot/x86_64/vmlinuz-linux-tos $CMD_LINE tos.rescue=1 img_dev=/dev/disk/by-uuid/$rescue_partition_UUID img_loop=/rescue.iso
    echo 'Loading initial ramdisk ...' 
    initrd (loop)/tos/boot/intel-ucode.img (loop)/tos/boot/amd-ucode.img (loop)/tos/boot/x86_64/initramfs-linux-tos.img
}

EOF

# install the new version of the grub config
grub-mkconfig -o /boot/grub/grub.cfg

}



########################################
########## SCRIPT STARTS HERE ##########
########################################

do_common_systemd
do_logind_suspend_state
do_clean_archiso
do_tos
do_rescue
rm -rf /usr/bin/installer
rm -rf /usr/bin/cleaner_script.sh


