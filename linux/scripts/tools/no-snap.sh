#!/bin/bash
echo "Attention: This script is optimized for a fresh install of Ubuntu 22.04 LTS"

snap remove firefox gtk-common-themes gnome-3-38-2004 snapd-desktop-integration snap-store
snap remove core20
snap remove bare
snap remove snapd

snap list
echo "If there are packages left remove them first, before preceding"
read -p "[ENTER] to continue [CTRL-C] to abort"

sudo systemctl stop snapd
sudo systemctl disable snapd
sudo systemctl mask snapd

sudo apt purge snapd -y
sudo apt-mark hold snapd

rm -rf ~/snap/

cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
# To prevent repository packages from triggering the installation of Snap,
# this file forbids snapd from being installed by APT.
# For more information: https://linuxmint-user-guide.readthedocs.io/en/latest/snap.html

Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

echo "Plese check /var and /var/lib for remains of snap - in case this wasn't a fresh install"
