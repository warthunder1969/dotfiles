#!/bin/bash
#Warthunder's ZRAM Setup script
#Version 0.1
set -euo pipefail
# Check for zram device exists in /dev
if ls /dev/zram* > /dev/null 2>&1; then
    echo "zram is enabled."
    zramctl
else
fi
# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
ZRAM_MODULE="zram"
ZRAM_DEVICES=1
RAM_FRACTION=0.5
MAX_SIZE_BYTES=$((2 * 1024 * 1024 * 1024))   # 2 GiB cap by default
PRIO=100
SYSTEMD_UNIT_PATH="/etc/systemd/system/zram.service"

# Define the Title and the Summary Message
DIALOG_TITLE="WELCOME"

# Use triple quotes for cleaner multi-line strings in the message
SCRIPT_SUMMARY="
Welcome to Warthunder's ZRAM Setup Script!

This tutorial aims to provide steps to enable
and configure ZRAM on Debian Based Systems.

1. Enable ZRAM
2. Adapt the config file
3. Optimize options for the use of swap on ZRAM

This script is provided as-is. Press OK to Continue.
"
dialog --clear \
    --title "$DIALOG_TITLE" \
    --msgbox "$SCRIPT_SUMMARY" 15 60 \
    2>&1 >/dev/tty

# Clear the dialog screen upon exit
clear

# Ensure running as root
if [ "$EUID" -ne 0 ]; then
  log "Please run as root (sudo)."
  exit 1
fi

log "Installing required packages..."
sudo apt install -y zram-tools

# Checking for Ram Capacity. If <=4GB go with better compression
TOTAL_RAM=$(free -m | awk '/^Mem:/{print $2}')
THRESHOLD=4096

if [ "$TOTAL_RAM" -le "$THRESHOLD" ]; then
    echo "Using zstd compression"
   sed -i 's/^.*#ALGO=lz4*$/ALGO=zstd/' /etc/default/zramswap
else
    echo "Using lz4 compression"
    sed -i 's/^.*#ALGO=lz4*$/ALGO=lz4/' /etc/default/zramswap
fi

sed -i 's/^.*#PERCENT=50*$/PERCENT=50/' /etc/default/zramswap

# Add Text to sysctl but only if its not there
LINE="vm.page-cluster = 0"
FILE="/etc/sysctl.conf"

if ! grep -qxF "$LINE" "$FILE"; then
  echo "$LINE" >> "$FILE"
fi

echo "a System Reboot is Required for Changes to take Affect."
