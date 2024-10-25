#!/bin/bash
#For Linux Mint 18.3 & LMDE4 systems and newer
# Updates
echo "************************************"
echo "Updating and Installing Nala for APT"
echo "************************************"
sudo apt-get install nala -y
sudo nala update

# Multimedia CODECs
echo "***********************"
echo "Installing Media Codecs"
echo "***********************"
sudo nala install mint-meta-codecs -y

# Install Native System Packages
echo "************************************"
echo "Installing Native System Packages"
echo "************************************"

sudo nala install git nfs-common gparted xsensors cheese bashtop micro xsct flameshot chromium -y

# Upgrade What's left
echo "*******************"
echo "Full System Upgrade"
echo "*******************"

sudo nala upgrade -y

# Autoremove
echo "**************************"
echo "Doing Debloat & Autoremove"
echo "**************************"

sudo nala remove -y transmission-gtk hypnotix
sudo nala autoremove -y

# Install Flatpaks & Overrides
echo "*******************"
echo "Installing Flatpaks"
echo "*******************"

flatpak install -y flathub com.discordapp.Discord com.google.Chrome im.riot.Riot com.notesnook.Notesnook

sudo flatpak override --device=dri
sudo flatpak override --filesystem=home
flatpak --user override --filesystem=/home/$USER/.icons/:ro
flatpak --user override --filesystem=/usr/share/icons/:ro


flatpak override --user --env XCURSOR_THEME=$((gsettings get org.cinnamon.desktop.interface cursor-theme) | (sed 's/^.//;s/.$//')) && flatpak override --user --env XCURSOR_SIZE=$(gsettings get org.cinnamon.desktop.interface cursor-size)
