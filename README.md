```
 ________  ________  ________  ___  ________  _________  ________
|\   ____\|\   ____\|\   __  \|\  \|\   __  \|\___   ___\\   ____\
\ \  \___|\ \  \___|\ \  \|\  \ \  \ \  \|\  \|___ \  \_\ \  \___|_
 \ \_____  \ \  \    \ \   _  _\ \  \ \   ____\   \ \  \ \ \_____  \
  \|____|\  \ \  \____\ \  \\  \\ \  \ \  \___|    \ \  \ \|____|\  \
    ____\_\  \ \_______\ \__\\ _\\ \__\ \__\        \ \__\  ____\_\  \
   |\_________\|_______|\|__|\|__|\|__|\|__|         \|__| |\_________\
   \|_________|                                            \|_________|

```

# helper scripts

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/built-by-developers.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/you-didnt-ask-for-this.svg)](https://forthebadge.com)

> This repo contains helper scripts for the [dotfile](https://github.com/F0xedb/dotfiles) repo

## Prerequisite

- bash
- polybar
- pacman (arch users only)
- xrandr
- emoji file found in this [repo](https://github.com/F0xedb/dotfiles)

## Explanation

- keepalive

  - Checks if polybar works
  - In case something broke restart polybar

- power

  - Lists the current power usage
  - Also the current and voltage
  - Currently only works for computers with voltage and energy sensors

- rankmirror

  - Creates a backup of your pacman mirrorlist
  - orders the newly created mirrorlist by speed between your computer and the server

- rofiquestion

  - ask a question through rofi.
  - if the answer is yes execute a command

- rofiselect
  - returns a list of scripts in the rofi directory
  - executes the selected script

## example

Ask the user if they want to reboot. If the answer is yes then execute the second parameter as a command

```
rofiquestion "Do you want to reboot" "sudo -A systemctl reboot"
```
