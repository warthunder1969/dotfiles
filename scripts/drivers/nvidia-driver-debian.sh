#!/bin/bash
# init

#Packages
echo 'Installing packages'
sudo nala update
sudo nala install nvidia-detect
nvidia-detect

#Calibration / services
echo 'grabbing nvidia & cuda'

sudo nala install -y linux-headers-amd64 nvidia-driver firmware-misc-nonfree nvidia-cuda-dev nvidia-cuda-toolkit nvidia-xconfig bumblebee-nvidia primus-nvidia primus-vk-nvidia primus-libs:i386 libprimus-vk1:i386 nvidia-primus-vk-wrapper:i386 xserver-xorg-input-mouse xserver-xorg-input-kbd

sudo nala remove xserver-xorg-legacy -y

sudo mkdir /etc/bumblebee/
sudo touch /etc/bumblebee/xorg.conf.nvidia
sudo sh -c 'echo "Section "Screen""
    Identifier "Default Screen"
    Device "DiscreteNvidia"
EndSection"' >> /etc/bumblebee/xorg.conf.nvidia

echo 'add the bus id to the /etc/bumblebee/xorg.conf.nvidia file:'
lspci | egrep 'VGA|3D'

sudo systemctl restart bumblebeed.service

echo 'if all is well you should see a gear show up'
primusrun glxgears -info

echo 'reboot recommended'

