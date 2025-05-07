#!/bin/bash
#For Linux Mint 18.3 & LMDE4 systems and newer
# Updates
echo "************************************"
echo "Updating and Installing Nala for APT"
echo "************************************"
sudo apt-get install nala -y
sudo nala update

# Multimedia CODECs
echo "*********************************"
echo "Installing Media Codecs and Fonts"
echo "*********************************"
sudo nala install ubuntu-restricted-extras -y

# Install Native System Packages
echo "************************************"
echo "Installing Native System Packages"
echo "************************************"

sudo nala install git gparted xsensors cheese btop speedtest-cli micro xsct flameshot vlc nextcloud-desktop duf caffeine -y

# Upgrade What's left
echo "*******************"
echo "Full System Upgrade"
echo "*******************"

sudo nala upgrade -y

# Autoremove
echo "**************************"
echo "Doing Debloat & Autoremove"
echo "**************************"

sudo nala autoremove -y

# Install Flatpaks & Overrides
echo "*******************"
echo "Installing Flatpaks"
echo "*******************"

flatpak install -y flathub com.discordapp.Discord com.google.Chrome im.riot.Riot com.notesnook.Notesnook flathub org.localsend.localsend_app

sudo flatpak override --device=dri
sudo flatpak override --filesystem=home
