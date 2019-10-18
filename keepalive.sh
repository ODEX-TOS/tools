#!/bin/bash

# MIT License
# 
# Copyright (c) 2019 Meyers Tom
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
function xorg {
    live=$(pgrep --list-full polybar | awk '{print $3}')
    bIsMain=False
    bIsWorkspace=False
    for item in $live
    do
        if [ "$item" == "main" ]; then
                bIsMain=True
        fi

        if [ "$item" == "workspaces" ]; then
                bIsWorkspace=True
        fi
    done
    if [ "$bIsMain" == False ]; then
            nohup polybar main &>/dev/null &
    fi
    if [ "$bIsWorkspace" == False ]; then
            nohup polybar workspaces &> /dev/null &
    fi

}

function wayland { 
    live=$(pgrep --list-name waybar | awk '{print $2}')
    bIsAlive=False
    for item in $live
    do
        if [ "$item" == "waybar" ]; then
                bIsAlive=True
        fi
    done
    if [ "$bIsAlive" == False ]; then
            nohup waybar &>/dev/null &
    fi
}

while true
do
    display=$(pgrep --list-name sway | awk '$2 ~ /^sway$/{print $2}')
    echo "$display"
    if [[ "$display" == "sway" ]]; then
            wayland
    else
            xorg
    fi
    sleep 5
done

