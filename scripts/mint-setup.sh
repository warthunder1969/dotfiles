#!/bin/bash
#For Linux Mint 18.3 & LMDE4 systems and newer
# Updates
echo "------------------------------------"
echo "Updating and Installing Nala for APT"
echo "------------------------------------"
sudo apt-get install nala -y
sudo nala upgrade -y

# Multimedia CODECs
echo "---------------------------------"
echo "Installing Media Codecs and Fonts"
echo "---------------------------------"
sudo nala install mint-meta-codecs -y
sudo nala install ttf-mscorefonts-installer -y

# Install Native System Packages
echo "----------------"
echo "Installing Apps"
echo "----------------"
sudo nala install $(cat packages.list)
flatpak install -y $(cat flatpak.list)
# Autoremove
echo "--------------------------"
echo "Doing Debloat & Autoremove"
echo "--------------------------"

sudo nala autoremove -y
sudo nala remove $(cat purge.list)

# Install Flatpaks & Overrides
echo "--------------"
echo "System Tweaks"
echo "--------------"
sudo flatpak override --device=dri
sudo flatpak override --filesystem=home

dconf load /org/cinnamon/ < $HOME/dotfiles/config/cinnamon/cin-x1.0
dconf load /org/cinnamon/desktop/keybindings/ < $HOME/dotfiles/config/cinnamon/mykeybindings
cinnamon --replace & disown

echo "A Reboot Is Recomended."
echo "DONE!"
