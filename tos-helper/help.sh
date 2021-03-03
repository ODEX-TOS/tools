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

function help() {
  printf "$ORANGE $name ${NC}OPTIONS: bluetooth|gpg|info|network|screen|theme|volume -c -h -rs -u -Q -R- -S -iso\n\n" "$ORANGE" "$name" "$NC"
  printf "${ORANGE}USAGE:$NC\n"
  printf "$name bluetooth \t\t\t Control all bluetooth settings \n"
  printf "$name gpg \t\t\t Configuration for your gpg/pgp keys\n"
  printf "$name info \t\t\t Print information about your system/environment\n"
  printf "$name network \t\t\t Control all network related settings\n"
  printf "$name screen \t\t\t Control all screen related settings\n"
  printf "$name theme \t\t\t Control all theme related settings\n"
  printf "$name volume \t\t\t Control the volume\n"
  printf "$name shell \t\t\t Run an application in an isolated environment to keep the host system clean\n"
  printf "$name -c | --cypto \t\t generate a crypto key \n"
  printf "$name -c | --cypto <user@ip> \t copy over your ssh key to a remote computer \n"
  printf "$name -h | --help \t\t Show this help message \n"
  printf "$name -p | --profile <picture>\t Set the user profile picture \n"
  printf "$name -t | --true-color \t\t Test the true-color capability of your terminal  \n"
  printf "$name -Q \t\t\t\t Query the local database of packages  \n"
  printf "$name -R \t\t\t\t Remove software from the system  \n"
  printf "$name -S \t\t\t\t Search the online database  \n"

}

help
