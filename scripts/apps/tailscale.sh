#!/bin/sh
#Warthunder's Tailscale Installation Script
#Version 1.2

#Variables
dependencies="curl"
package="tailscale-systray"
#Tailscale Linux Install
#https://tailscale.com/download
curl -fsSL https://tailscale.com/install.sh | sh

#Tray Applet
#Source: https://github.com/mattn/tailscale-systray
#Easy Installer: https://github.com/C10udburst/tailscale-systray

curl -fsSL https://raw.githubusercontent.com/C10udburst/tailscale-systray/master/install.txt | sh

cp ~/.config/autostart/tailscale-systray.desktop ~/.local/share/applications/

exit 
