#virtmanager install

sudo apt install qemu-kvm qemu-system libvirt-daemon-system libvirt-clients bridge-utils virt-manager -y

#Create and Add user to KVM group
sudo adduser $USER kvm
sudo adduser $USER libvirt
