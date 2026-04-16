#!/bin/bash
# Installer script for My Perfered Fonts on Linux Mint. Should work for most Debian or Ubuntu based systems
# Version 1.0

#Install Fonts
sudo apt install fonts-noto fonts-jetbrains-mono
sudo apt install -yy ttf-mscorefonts-installer

# Update the font cache
fc-cache -f -v

# Set Fonts
gsettings set org.cinnamon.desktop.interface font-name "Noto Sans Regular 10"
gsettings set org.nemo.desktop font "Noto Sans Regular 12"
gsettings set org.cinnamon.desktop.interface monospace-font-name "Noto Sans Mono Regular 10"
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Noto Sans Bold 10"
		
echo "Fonts installed successfully!"
