#!/bin/bash
#Warthunder's QEMU installation script
#version 1.1

# Check for Intel VT-x (vmx) or AMD-V (svm) flags in /proc/cpuinfo
if grep -E --color 'vmx|svm' /proc/cpuinfo > /dev/null; then
    echo "Hardware virtualization (Intel VT-x or AMD-V) is ENABLED."
else
    echo "Hardware virtualization (Intel VT-x or AMD-V) is DISABLED."
	echo "Error virtualization is disabled. KVM will not work without virtualization."	
fi

#Install 
echo "Installing QEMU"
sudo apt install-y qemu-system-x86 libvirt-daemon-system virtinst virt-manager virt-viewer ovmf swtpm qemu-utils guestfs-tools libosinfo-bin tuned

#Add User to Necessary Groups
sudo adduser $USER libvirt
sudo adduser $USER kvm


#Enable system daemon
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

#Checking to see we're good
sudo virt-host-validate qemu

echo "QEMU Installed"
