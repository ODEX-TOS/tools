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
esac

