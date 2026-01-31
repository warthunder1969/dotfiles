#!/bin/bash

# Define the KVM modules based on CPU type
if grep -q vmx /proc/cpuinfo; then
    KVM_MOD="kvm_intel"
elif grep -q svm /proc/cpuinfo; then
    KVM_MOD="kvm_amd"
fi

# Function to unload KVM
unload_kvm() {
    echo "Unloading KVM modules ($KVM_MOD)..."
    sudo modprobe -r $KVM_MOD kvm
}

# Function to reload KVM
load_kvm() {
    echo "Reloading KVM modules ($KVM_MOD)..."
    sudo modprobe $KVM_MOD
}

# 1. Unload KVM
unload_kvm

# 2. Launch VirtualBox and wait for it to close
echo "Launching VirtualBox..."
gtk2 virtualBox %U

# 3. Reload KVM after VirtualBox exits
load_kvm

echo "KVM restored. Done."
