#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run this script as root, for example: sudo $0"
  exit 1
fi

cpu_vendor=$(awk -F: '/vendor_id/ { gsub(/[[:space:]]/, "", $2); print $2; exit }' /proc/cpuinfo)

case "$cpu_vendor" in
  GenuineIntel) cpu_module=kvm_intel ;;
  AuthenticAMD) cpu_module=kvm_amd ;;
  *)
    echo "Could not identify an Intel or AMD CPU."
    exit 1
    ;;
esac

unload_kvm() {
  echo "Unloading KVM modules..."
  modprobe -r "$cpu_module" kvm
  echo "KVM modules unloaded."
}

load_kvm() {
  echo "Loading KVM modules..."
  modprobe kvm
  modprobe "$cpu_module"
  echo "KVM modules loaded."
}

echo "1) Unload KVM modules (for VirtualBox)"
echo "2) Load KVM modules"
read -rp "Choose an option: " choice

case "$choice" in
  1) unload_kvm ;;
  2) load_kvm ;;
  *) echo "Invalid option."; exit 1 ;;
esac
