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
echo "Gathering system info..."


OS=$(grep "^NAME" /etc/os-release | cut -d"=" -f2 | tr -d '"')

CPU_USAGE="$(ps aux | awk '{count+=$3}END{printf count}')"
CORES=$(grep -Ec "cpu[0-9]+" /proc/stat)

MEM_USAGE="$(ps aux | awk '{count+=$4}END{printf count}')"
MEM_SIZE="$(free -h | awk 'NR==2{printf $2}')"

PACKAGES="$(pacman -Q | wc -l)"

DESKTOP="$XDG_SESSION_DESKTOP"
WINDOWING_SYSTEM=$(pgrep "Xorg" &>/dev/null && echo "X11" || echo "Wayland")

clear

echo -e "OS: \t\t\t\t $OS"
echo
echo -e "CPU Usage: \t\t\t $CPU_USAGE%"
echo -e "CPU Cores: \t\t\t $CORES"
echo -e "MEMORY Usage: \t\t\t $MEM_USAGE%"
echo -e "Memory size: \t\t\t $MEM_SIZE"
echo
echo -e "Packages installed: \t\t $PACKAGES"
echo
echo -e "Desktop: \t\t\t $DESKTOP"
echo -e "Windowing system: \t\t $WINDOWING_SYSTEM"
read -r


