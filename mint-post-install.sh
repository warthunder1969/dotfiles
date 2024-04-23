#!/bin/bash

# Update apt
sudo apt install nala -y
sudo nala update

# Multimedia CODECs
sudo nala install mint-meta-codecs -y

# Install Native System Packages
sudo nala install git nfs-common gparted xsensors guvcview bpytop -y

# Install non-repo packages
#Discord APT - see github repo: https://github.com/palfrey/discord-apt
touch /etc/apt/sources.list.d/discord.list
echo 'deb https://palfrey.github.io/discord-apt/debian/ ./' >> /etc/apt/sources.list.d/discord.list
wget -O /etc/apt/trusted.gpg.d/discord-apt.gpg.asc  https://palfrey.github.io/discord-apt/discord-apt.gpg.asc
sudo nala update
sudo nala install -y discord

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo nala install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
# Great Purge

# Upgrade Packages
sudo nala upgrade -y

# Autoremove
sudo nala autoremove -y

# Install flatpaks
flatpak install -y flathub com.sindresorhus.Caprine com.notesnook.Notesnook

