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

# find all touchpads and enable Tapping if it has that functionality. This is for xorg based window managers
function xorg {
    for pad in $(xinput list | grep Touchpad | awk '{print $6}' | awk -F= '{print $2}'); do
        for prop in $(xinput list-props "$pad" | grep "Tapping Enabled" | awk -F\( '{print $2}' | awk -F\) '{print $1}'); do
            xinput set-prop "$pad" "$prop" 1 &>/dev/null 
        done
    done
}


# to the same as the xorg variant but for sway (this only works for sway)
function wayland {
    id=$(swaymsg -t get_inputs | grep -E 'identifier.*Touchpad' | awk -F\" '{print $4}')
    swaymsg input "$id" tap enabled
}


sleep 5

display=$(pgrep --list-name sway | awk '$2 ~ /^sway$/{print $2}')
echo "$display"
if [[ "$display" == "sway" ]]; then
    wayland
else
    xorg
fi

