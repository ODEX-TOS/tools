#!/bin/bash

function installtosdialog() {
	printf "${RED}Installing tos${NC}\n"
	if [[ ! -f dialogarchinstall ]]; then
		curl https://raw.githubusercontent.com/ODEX-TOS/tools/master/tosinstall -o tosinstall
		chmod +x tosinstall
	fi
    if [[ ! "$(command -v os-install)" ]]; then
            pacman -Syu installer-backend --noconfirm
	fi
	if [[ ! -d "$HOME"/cli ]]; then
		git clone https://github.com/ODEX-TOS/installer-curses "$HOME"/cli
	fi
	bash "$HOME"/cli/install.sh || exit 1
	os-install --in gen.yaml --out run.sh || exit 1
	bash run.sh
}
case "$1" in
"-iso")
	if [ "$(id -u)" == "0" ]; then
		installtosdialog
	else
		printf "${RED} Only root user can install TOS${NC}\n"
	fi
	;;
esac
