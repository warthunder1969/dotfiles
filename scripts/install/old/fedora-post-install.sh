#!/bin/bash
#For Linux Mint 18.3 & LMDE4 systems and newer
# Updates
echo "*******************"
echo "Full System Upgrade"
echo "*******************"
sudo dnf update -y

# Multimedia CODECs
echo "************************************"
echo "Enabling the RPM Fusion repositories"
echo "************************************"
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y

  sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
echo "****************************"
echo "Installing Multimedia Codecs"
echo "****************************"
sudo dnf group install multimedia
sudo dnf swap  ffmpeg ffmpeg-free --allowerasing
sudo dnf install libavcodec-freeworld ffmpeg --allowerasing
sudo dnf install gstreamer1-plugins-bad-freeworld
sudo dnf install intel-media-driver

# Install Native System Packages
echo "************************************"
echo "Installing Native System Packages"
echo "************************************"

sudo dnf install git gparted thunderbird fastfetch btop speedtest-cli micro flameshot vlc nextcloud-client duf timeshift -y

# Autoremove
echo "**************************"
echo "Doing Debloat & Autoremove"
echo "**************************"

sudo dnf remove kmahjongg kmines kpat -y

# Install Flatpaks & Overrides
echo "*******************"
echo "Installing Flatpaks"
echo "*******************"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.discordapp.Discord com.google.Chrome im.riot.Riot com.notesnook.Notesnook flathub org.localsend.localsend_app

sudo flatpak override --device=dri
sudo flatpak override --filesystem=home
