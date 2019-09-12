#!/bin/bash

# find all touchpads and enable Tapping if it has that functionality

for pad in $(xinput list | grep Touchpad | awk '{print $6}' | awk -F= '{print $2}'); do
    for prop in $(xinput list-props "$pad" | grep "Tapping Enabled" | awk -F\( '{print $2}' | awk -F\) '{print $1}'); do
            xinput set-prop "$pad" "$prop" 1 &>/dev/null 
    done
done
