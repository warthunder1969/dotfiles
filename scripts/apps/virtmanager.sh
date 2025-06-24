#!/bin/sh
#source: https://gist.github.com/solvaholic/8b79d52a82ecb780244eaa44ea54d783#manage-storage-volumes
#Checking for Virtualization
virt="egrep -c '(vmw|svm)' /proc/cpuinfo"
if [ virt=0 ]; then
echo "Virtualization isn't available. KVM won't work properly until you do so."
fi

# Install packages
sudo apt install qemu qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils virt-manager

#Giving Permissions to logged in User
sudo usermod -aG libvert $USER
sudo usermod -aG kvm $USER

#System Services
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

echo "Log out, and log back in (to get your new libvirtd group membership)"
