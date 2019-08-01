#!/bin/bash

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
    killall polybar # should restart with the keepalive script
    nohup polybar main &> /dev/null &
    nohup polybar workspaces &> /dev/null &
    wal -R

}

case "$2" in
    "get"|"g")
        xrandr
    ;;
    "d"|"duplicate")
        screen-duplicate $3 $4
        screen-reload
    ;;
    "t"|"toggle")
        xrandr --output $3 --$4
        screen-reload
    ;;
    "r"|"reset")
        xrandr --output $3 --auto
        screen-reload
    ;;
    "res"|"resolution")
        xrandr --output $3 --mode $4
        screen-reload
    ;;
    "rate"|"refresh")
        xrandr --output $3 --rate $4
        screen-reload
    ;;
esac