#!/bin/bash
function help {
        subname="screen"
        printf "${ORANGE} $name $subname ${NC}OPTIONS: get | add | duplicate | toggle | reset | refresh | resolution | help\n\n" 
        printf "${ORANGE}USAGE:${NC}\n"
        printf "$name $subname help \t\t\t\t\t Show this help message\n"
        printf "$name $subname get  \t\t\t\t\t Get the current screen information\n"
        printf "$name $subname add <screen> <size> \t\t\t\t Add a size to the current screen. In case the size wasn't detected eg eDP1 1920x1080\n"
        printf "$name $subname duplicate <in> <out> \t\t\t Duplicate the screen in to screen out\n"
        printf "$name $subname toggle <screen> <on|off>\t\t\t Toggle a display on or off\n"
        printf "$name $subname reset <screen> \t\t\t\t Reset screen to it's default values\n"
        printf "$name $subname refresh <screen> <Hz> \t\t\t Change the refresh rate of the screen\n"
        printf "$name $subname resolution <screen> <width>x<height> \t Set the resolution of screen to certain WidthxHeight \n"
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
    killall polybar waybar # should restart with the keepalive script
    nohup ~/bin/keepalive.sh &> /dev/null &
    wal -R
}

function add {
    monitor="$1"
    res="$2"
    height=$(printf "%s" "$res" | awk -Fx '{print $1}')
    width=$(printf "%s" "$res" | awk -Fx '{print $2}')
    modeline=$(gtf "$height" "$width" 60 | head -n3 | tail -n1 | sed 's;.*Modeline ;;' | awk '{print $1}' | sed 's;";;g')
    xrandr --newmode "$modeline" $(gtf "$height" "$width" 60 | head -n3 |  tail -n1 | sed 's;.*Modeline ".*"  ;;')
    xrandr --addmode "$monitor" "$modeline"
    xrandr --output "$monitor" --mode "$modeline"
}


case "$2" in
    "get"|"g")
        xrandr
    ;;
    "a"|"add")
        add "$3" "$4"
        screen-reload
    ;;
    "d"|"duplicate")
        screen-duplicate "$3" "$4"
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
        xrandr --output "$3" --rate "$4"
        screen-reload
    ;;
    "-h"|"--help"|"help"|"h")
        help
    ;;   
esac
