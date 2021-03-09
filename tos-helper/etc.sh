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

function info {
	status="${GREEN}healthy${NC}"
	if [[ "$(find ~/.cache/tde/ -amin -30 -iname error.log | wc -l)" -gt "0" ]]; then
		status="${RED}unhealthy${NC}"
		unhealthy="${RED}HEALTH STATUS:${NC}"
	fi
	updates="$(checkupdates-tos | sed ':a;N;$!ba;s/\n/---___---/g')"
	if [[ "$(echo -e "$updates" | wc -l)" -gt "1" ]]; then
		status="${RED}unhealthy${NC}"
		unhealthy="${RED}HEALTH STATUS:${NC}"
	fi

	echo -e "${ORANGE}STATUS:${NC} \t\t\t\t $status"
	echo ""
	echo -e "${ORANGE}TDE:${NC}"
	echo -e "\tVersion: \t\t\t $(tde-client "return awesome.version" | awk '{print $2}' | tr -d '"')"
	echo -e "\tType: \t\t\t\t $(tde-client "return awesome.release" | awk '{print $2}' | tr -d '"')"
	echo -e "\tRelease: \t\t\t $(tde-client "return require('release')" | awk '{print $2}' | tr -d '"')"
	# shellcheck disable=SC2009,SC2046
	echo -e "\tCPU usage: \t\t\t $(ps -aux | grep $(pgrep tde) | head -n1 | awk '{print $3"%"}')"
	echo ""
	echo -e "${ORANGE}TOS:${NC}"
	echo -e "\tVersion: \t\t\t $(cat /etc/version)"
	echo -e "\tPackages: \t\t\t $(pacman -Q | wc -l)"
	echo -e "\tUptime: \t\t\t $(uptime -p)"
	echo -e "\tKernel: \t\t\t $(uname -r)"

	if [[ -n "$unhealthy" ]]; then
		echo ""
		echo -e "$unhealthy"
		tail -n20 ~/.cache/tde/error.log  | awk '{print "\tINFO: \t\t\t\t", $0}'
		echo ""
		while IFS= read -r line
		do
			echo -e "\tUPDATES:\t\t\t $line"
		done <<< "$(echo -e "$updates" | sed 's/---___---/\n/g')"
	fi
}

case "$1" in
    "-c"|"--crypto")
        if [ "$2" == "" ]; then
               ssh-keygen
        else
               ssh-copy-id "$2"
        fi 
    ;;
    "-t"|"--true-color")
		seconds=${2:-1}
    	cols=$(tput cols)
    	rows=$(tput lines)
   
    	for x in $(seq 1 "$seconds"); do
        	clear
         	b=$(( 255 - $(( x * 255 / seconds )) ))
         	for i in $(seq 1 "$rows"); do
            	for j in $(seq 1 "$cols"); do
                	r=$(( 255 - $((i*255/rows )) ))
                	g=$(( 255 - $((j*255/cols )) ))
                    printf "\033[48;2;%s;%s;%sm \033[0m" "$r" "$g" "$b"
                done
             	echo
         	done
        sleep 0.5
    	done
    ;;
	"i"|"info")
		info
	;;
esac

