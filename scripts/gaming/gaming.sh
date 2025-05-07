#!/bin/bash
# init

# INSTALL WINE
echo "Installing WINE"

sudo dpkg --add-architecture i386 

sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

#For Ubuntu 22.04-based
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
#Stable Branch
sudo apt update
sudo apt install --install-recommends winehq-stable

# INSTALL WINETRICKS
echo "Installing Winetricks"

wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo cp winetricks /usr/local/bin

# INSTALL LUTRIS
echo "Installing Lutris"
sudo add-apt-repository -y ppa:lutris-team/lutris
sudo apt -y update
sudo apt -y install lutris
echo "Installing Gamemode"
sudo apt -y install meson libsystemd-dev pkg-config ninja-build git libdbus-1-dev libinih-dev build-essential
git clone https://github.com/FeralInteractive/gamemode.git
cd gamemode
git checkout 1.7
./bootstrap.sh

# WINETRICKS DEPENDENCIES
winetricks -q -v d3dx10 d3dx9 dotnet35 dotnet40 dotnet45 dotnet48 dxvk vcrun2008 vcrun2010 vcrun2012 vcrun2019 vcrun6sp6

#vulkan and mesa drivers
sudo apt install mesa-vulkan-drivers:i386 libvulkan1:i386
sudo apt install dxvk

#steam

sudo apt install steam
flatpak install com.heroicgameslauncher.hgl
