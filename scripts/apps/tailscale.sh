#!/bin/sh
#Warthunder's Tailscale Installation Script
#Version 1.3

#Variables
dependencies="curl"
package="tailscale-systray"
#Tailscale Linux Install
#https://tailscale.com/download
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale set --operator=$USER
exit 
