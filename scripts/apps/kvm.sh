#!/bin/bash
#Warthunder's KVM installation script
#version 1.0

#Set variables
vm_support="lscpu | grep -i virtualization"

#Check for Virtualization Support
if $vm_support = VT-x or AMD-V
echo "virtualization is supported. Continuing"
else echo "error virtualization is disabled. KVM will not work without virtualization"

#install KVM
sudo apt install qemu-system-x86 libvirt-daemon-system virtinst virt-manager virt-viewer ovmf swtpm qemu-utils guestfs-tools libosinfo-bin tuned

#enable system daemon
sudo systemctl enable libvirtd.service

#checking to see we're good
sudo virt-host-validate qemu
