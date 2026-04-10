#!/bin/sh
#Warthunder's Twingate Installation Script
#Version 1.0
#source:https://www.twingate.com/docs/linux
#source:https://github.com/sfnemis/twingate-linux-desktop-client


#Variables
dependencies="curl" "git"
sudo apt install curl git gir1.2-ayatanaappindicator3-0.1 xclip
#Tailscale Linux Install
#https://tailscale.com/download
curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash
sudo twingate setup

#Systray
cd 
git clone https://github.com/sfnemis/twingate-linux-desktop-client.git
cd twingate-linux-desktop-client
sudo ./setup.sh

exit 
