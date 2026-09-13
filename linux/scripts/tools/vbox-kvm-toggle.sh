#!/bin/bash
# toggle_kvm_for_vbox.sh
# Toggles KVM (kvm, kvm_intel / kvm_amd) on or off.

set -e

# Detect CPU vendor
CPU_VENDOR=$(grep -m1 '^vendor_id' /proc/cpuinfo | awk '{print $3}')

# Relevant modules
MOD_MAIN="kvm"
if [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
    MOD_CPU="kvm_intel"
else
    MOD_CPU="kvm_amd"
fi

# Check if KVM is loaded
if lsmod | grep -q "^$MOD_MAIN"; then
    echo "KVM is currently loaded — disabling it..."
    sudo modprobe -r "$MOD_CPU" || echo "Could not remove $MOD_CPU (maybe not loaded)"
    sudo modprobe -r "$MOD_MAIN" || echo "Could not remove $MOD_MAIN"
    echo "KVM disabled."
else
    echo "KVM is currently not loaded — enabling it..."
    sudo modprobe "$MOD_MAIN"
    sudo modprobe "$MOD_CPU"
    echo "KVM enabled."
fi
