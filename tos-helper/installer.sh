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

# shellcheck disable=SC2059,SC2154


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
		printf "${RED} This installer is outdated and no longer works${NC}\n"
		printf "${RED} Use ${GREEN}tos calamares${RED} to install tos the correct way${NC}\n"
		exit 1
		# this function no longer works as expected
		installtosdialog
	else
		printf "${RED} Only root user can install TOS${NC}\n"
	fi
	;;
esac

