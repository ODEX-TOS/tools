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
# This source statement must be present at the top of this file
source "$framework"

# Informe the user of whats about to happen
prmpt "Installing some software"

# install packages to the user system
packages git wget

# Ask the user something "yes" is the default respones
ask "Do you want to install something custom?" "yes"

# $result stores the user respones
if [[ "$result" == "yes" ]]; then
    prmpt "You answered yes"
else
    prmpt "You didn't do what I wanted :( instead you answerd $result "
fi

# download repo.odex.be to $HOME/test/testfile
# If the directory doesn't exist it will be created
# important dont end the directory with a /
download "$HOME"/test testfile "https://repo.odex.be" 

prmpt "The installation is done!!"

