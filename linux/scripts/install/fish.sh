#!/bin/bash
#Warthunder's ZRAM Setup script
#Version 0.1
set -euo pipefail
# Check for zram device exists in /dev
# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables

# Define the Title and the Summary Message
DIALOG_TITLE="WELCOME"

# Use triple quotes for cleaner multi-line strings in the message
SCRIPT_SUMMARY="
Welcome to Warthunder's Fish Shell Setup Script!

This tutorial aims to provide steps to enable
and configure Fish on Debian Based Systems.

1. Install Fish Shell
2. Adapt the config file

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
sudo apt install -y fish
exec fish
echo "a System Reboot is Required for Changes to take Affect."
