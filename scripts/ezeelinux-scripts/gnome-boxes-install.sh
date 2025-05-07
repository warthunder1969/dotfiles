#!/bin/bash

# Script to install and setup Gnome Boxes.

# Installation Command:
sudo apt install -yy gnome-boxes qemu-kvm libvirt-bin

# Add User to kvm:
sudo usermod -a -G kvm $USER

# Allow users in kvm group to start VMs:
sudo sed -i -e 's/\#group\ =\ "root"/group=kvm/g' /etc/libvirt/qemu.conf
