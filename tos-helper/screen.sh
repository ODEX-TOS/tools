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

function help {
        subname="screen"
        printf "${ORANGE} $name $subname ${NC}OPTIONS: get | add | duplicate | dpi | toggle | reset | refresh | resolution | help\n\n" 
        printf "${ORANGE}USAGE:${NC}\n"
        printf "$name $subname help \t\t\t\t\t Show this help message\n"
        printf "$name $subname get  \t\t\t\t\t Get the current screen information\n"
        printf "$name $subname add <screen> <size> \t\t\t\t Add a size to the current screen. In case the size wasn't detected eg eDP1 1920x1080\n"
        printf "$name $subname duplicate <in> <out> \t\t\t Duplicate the screen in to screen out\n"
        printf "$name $subname toggle <screen> <on|off>\t\t\t Toggle a display on or off\n"
        printf "$name $subname reset <screen> \t\t\t\t Reset screen to it's default values\n"
        printf "$name $subname refresh <screen> <Hz> \t\t\t Change the refresh rate of the screen\n"
        printf "$name $subname resolution <screen> <width>x<height> \t Set the resolution of screen to certain WidthxHeight \n"
        printf "$name $subname dpi <screen> <scaleX>x<scaleY> \t\t Scale the screen dpi to match your taste if scaleX = 1 then no scaling happens. To make everything twice as big do 0.5x0.5 \n"
}

function screen-duplicate  {
    primary=$1
    secondary=$2
    sizePrimary=$(xrandr | awk -v monitor="^$primary connected" '/connected/ {p = 0}$0 ~ monitor {p = 1}p' | head -n2 | tail -n1 | awk '{print $1}')

    sizeSecondary=$(xrandr | awk -v monitor="^$secondary connected" '/connected/ {p = 0}$0 ~ monitor {p = 1} p' | head -n2 | tail -n1 | awk '{print $1}')
    echo "primary monitor - $primary: $sizePrimary"
    echo "secondary monitor - $secondary: $sizeSecondary"
    xrandr --output "$primary" --rate 60 --mode "$sizePrimary" --fb "$sizePrimary" --panning "$sizePrimary" --output "$secondary" --mode "$sizeSecondary" --same-as "$primary"
    
}


# When updating the screen we should reload all components so that the can adjust to the new display specs
function screen-reload {
    if pgrep polybar; then
       killall polybar waybar # should restart with the keepalive script
      nohup ~/bin/keepalive.sh &> /dev/null &
    fi
    if which autorandr &>/dev/null ; then
        autorandr --save tde --force
    fi
}

function screen-dpi {
    dpi=$(echo "$2" | cut -dx -f1 | awk '{print (100* 1/$0)}')
    DEFAULT_FONT_SIZE="16"
    CALCULATED_FONT_SIZE=$(printf "$DEFAULT_FONT_SIZE" | awk -v "value=$dpi" '{printf int(($0 / 100 ) * value)}')
    sed -i 's:pixelsize=[0-9]*:pixelsize='"$CALCULATED_FONT_SIZE"':' ~/.Xresources
    sed -i 's/Xft.dpi: .*$/Xft.dpi: '"$dpi"'/g' ~/.Xresources
    xrdb ~/.Xresources
    # TODO: figure out why xrandr scaling no longer works
    # xrandr --output "$1" --scale "$2"
    if [[ ! -d "$HOME/.config/tos" ]]; then
        mkdir -p "$HOME/.config/tos"
    fi

    if [[ ! -f "$themefile" ]]; then
        printf "off\ntime=1000\nbluetooth=false\nscale=$1 $2\n" >>"$themefile"
    else
        sed -i 's:scale='"$1"'.*$:scale='"$1"' '"$2"':' "$HOME"/.config/tos/theme
    fi

}

function add {
    monitor="$1"
    res="$2"
    freq="$3"
    if [[ "$freq" == "" ]]; then
            freq="60"
    fi
    height=$(printf "%s" "$res" | awk -Fx '{print $1}')
    width=$(printf "%s" "$res" | awk -Fx '{print $2}')
    modeline=$(gtf "$height" "$width" "$freq" | head -n3 | tail -n1 | sed 's;.*Modeline ;;' | awk '{print $1}' | sed 's;";;g')
    xrandr --newmode "$modeline" "$(gtf "$height" "$width" "$freq" | head -n3 |  tail -n1 | sed 's;.*Modeline ".*"  ;;')"
    xrandr --addmode "$monitor" "$modeline"
    xrandr --output "$monitor" --mode "$modeline"
}


case "$2" in
    "get"|"g")
        xrandr
    ;;
    "a"|"add")
        add "$3" "$4" "$5"
        screen-reload
    ;;
    "d"|"duplicate")
        screen-duplicate "$3" "$4"
        screen-reload
    ;;
    "dp"|"dpi")
        screen-dpi "$3" "$4"
        screen-reload
    ;;
    "t"|"toggle")
        xrandr --output "$3" --"$4"
        screen-reload
    ;;
    "r"|"reset")
        xrandr --output "$3" --auto
        screen-reload
    ;;
    "res"|"resolution")
        xrandr --output "$3" --mode "$4"
        screen-reload
    ;;
    "rate"|"refresh")
        current_resolution="$(xrandr -q | grep "$3" | awk '{print $4}' | awk -F'+' '{print $1}')"
        xrandr --output "$3" --mode "$current_resolution" --rate "$4"
        screen-reload
    ;;
    "-h"|"--help"|"help"|"h"|"")
        help
    ;;   
esac

