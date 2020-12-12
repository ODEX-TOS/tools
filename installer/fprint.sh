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
source "$framework"

# Informe the user of whats about to happen
prmpt "Installing fprint software"
packages fwupd fprintd

ask "Do you need the prometheus synaptic drivers(y/N)?" "N"
if [[ "$result" == "y" || "$result" == "Y" ]]; then
    download /tmp/fprint-firmware config.cab "https://fwupd.org/downloads/cbe7b45a2591e9d149e00cd4bbf0ccbe5bb95da7-Synaptics-Prometheus_Config-0021.cab"
    download /tmp/fprint-firmware prometheus.cab "https://fwupd.org/downloads/3b5102b3430329a10a3636b4a594fc3dd2bfdc09-Synaptics-Prometheus-10.02.3110269.cab"
    fwupdmgr install /tmp/fprint-firmware/config.cab
    fwupdmgr install /tmp/fprint-firmware/prometheus.cab
fi

prmpt "Enrolling your right index finger now. In case this failes rerun the installer"
fprintd-enroll || exit 1
grep -q "auth required    pam_env.so
auth sufficient  pam_unix.so try_first_pass likeauth nullok
auth sufficient  pam_fprintd.so" /etc/pam.d/system-local-login || awk 'NR==1{print; print "auth      sufficient pam_fprintd.so"} NR!=1' /etc/pam.d/system-local-login 
grep -q "auth required    pam_env.so
auth sufficient  pam_unix.so try_first_pass likeauth nullok
auth sufficient  pam_fprintd.so" /etc/pam.d/login || awk 'NR==1{print; print "auth required    pam_env.so\nauth sufficient  pam_unix.so try_first_pass likeauth nullok\nauth sufficient  pam_fprintd.so"} NR!=1' /etc/pam.d/login 

ask "Do you want fingerprint support for your display manager? (Y/n)" "Y"
if [[ "$result" == "Y" || "$result" == "y" ]]; then
    if [[ -f "/etc/pam.d/sddm" ]]; then
        grep -q "auth required    pam_env.so
auth sufficient  pam_unix.so try_first_pass likeauth nullok
auth sufficient  pam_fprintd.so" /etc/pam.d/sddm || awk 'NR==1{print; print "auth required    pam_env.so\nauth sufficient  pam_unix.so try_first_pass likeauth nullok\nauth sufficient  pam_fprintd.so"} NR!=1' /etc/pam.d/sddm
    fi
fi

ask "Do you want fingerprint support for your sudo? (Y/n)" "Y"
if [[ "$result" == "Y" || "$result" == "y" ]]; then
    grep -q "auth required    pam_env.so
auth sufficient  pam_unix.so try_first_pass likeauth nullok
auth sufficient  pam_fprintd.so" /etc/pam.d/sudo || awk 'NR==1{print; print "auth required    pam_env.so\nauth sufficient  pam_unix.so try_first_pass likeauth nullok\nauth sufficient  pam_fprintd.so"} NR!=1' /etc/pam.d/sudo 
fi

ask "Do you want fingerprint support for your lockscreen? (Y/n)" "Y"
if [[ "$result" == "Y" || "$result" == "y" ]]; then
    grep -q "auth required    pam_env.so
auth sufficient  pam_unix.so try_first_pass likeauth nullok
auth sufficient  pam_fprintd.so
    " /etc/pam.d/i3lock || awk 'NR==1{print; print "auth required    pam_env.so\nauth sufficient  pam_unix.so try_first_pass likeauth nullok\nauth sufficient  pam_fprintd.so"} NR!=1' /etc/pam.d/i3lock 
fi
