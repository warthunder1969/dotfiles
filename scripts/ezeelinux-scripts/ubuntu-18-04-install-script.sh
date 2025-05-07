#!/bin/bash

# Ubuntu (GNOME) 18.04 setup script for Dell Precision T5400.
# By Joe Collins. (www.ezeelinux.com GNU/General Public License version 2.0)

# Must have Gdebi!:

dpkg -l | grep -qw gdebi || sudo apt-get install -yyq gdebi

# First, let's install a bunch of software:

sudo apt install -yy nvidia-340 net-tools htop grsync lame sound-juicer soundconverter \
openssh-server sshfs gedit-plugin-text-size simplescreenrecorder libreoffice \
ubuntu-restricted-extras mpv vlc gthumb gnome-tweaks tracker chrome-gnome-shell \
qt5-style-plugins spell synaptic gufw brasero git mc rhythmbox-plugin-cdrecorder \
gparted youtube-dl pavucontrol handbrake audacity cowsay

# Install all local .deb packages, if available:

if [ -d "/home/$USER/Downloads/Packages" ]; then
	echo "Installing local .deb packages..."
	pushd /home/$USER/Downloads/Packages
	for FILE in ./*.deb
    do
        sudo gdebi -n "$FILE"
    done
	popd
else
	echo $'\n'$"WARNING! There's no ~/Downloads/Packages directory."
	echo "Local .deb packages can't be automatically installed."
	sleep 5 # The script pauses so this message can be read. 
fi

# GNOME Boxes Installation.
# Installation Command:

sudo apt install -yy gnome-boxes qemu-kvm libvirt-bin

# Add User to kvm:
sudo usermod -a -G kvm $USER

# Allow users in kvm group to start VMs:
sudo sed -i -e 's/\#group\ =\ "root"/group=kvm/g' /etc/libvirt/qemu.conf
# Remove undesirable packages:

sudo apt purge gstreamer1.0-fluendo-mp3 deja-dup shotwell -yy

# Remove snaps and get packages from apt:

sudo snap remove gnome-characters gnome-calculator gnome-system-monitor
sudo apt install gnome-characters gnome-calculator gnome-system-monitor -yy

# Purge Firefox, install Google Chrome:

sudo apt purge firefox -yy
sudo apt purge firefox-locale-en -yy
if [ -d "/home/$USER/.mozilla" ]; then
	rm -rf /home/$USER/.mozilla
fi
if [ -d "/home/$USER/.cache/mozilla" ]; then
	rm -rf /home/$USER/.cache/mozilla
fi
mkdir /tmp/gc-install-tmp
pushd /tmp/gc-install-tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi -n google-chrome-stable_current_amd64.deb
popd
rm -rf /tmp/gc-install-tmp

# Install Timeshift:

sudo apt-add-repository -y ppa:teejee2008/ppa -y
sudo apt install timeshift

# Install mp3gain:

sudo add-apt-repository -y ppa:flexiondotorg/audio -y
sudo apt install mp3gain

# Set Qt variable in /etc/environment:

sudo bash -c "echo 'QT_QPA_PLATFORMTHEME=gtk2' >> /etc/environment"

# Brasero-Ubuntu 18.04 Bug Fix:
# Set permissions thusly to enable audio CD writing in Ubuntu 18.04:

sudo chmod 4711 /usr/bin/cdrdao
sudo chmod 4711 /usr/bin/wodim
sudo chmod 0755 /usr/bin/growisofs

# Gotta reboot now:

echo $'\n'$"*** All done! Please reboot now. ***"
exit

