#!/bin/bash
# Compress KVM virtual discs

# Ask for the Filename
FILENAME=$(whiptail --title "QCOW2 Compressor" --inputbox "Enter the filename (e.g., file.qcow2p):" 10 60 "recording" 3>&1 1>&2 2>&3)
FIENAME2="$FILENAME2"
# Exit if user cancels
if [ $? -ne 0 ]; then exit; fi

# Ask for the Location
SAVEDIR=$(whiptail --title "QCOW2 Compressor" --inputbox "Enter the output directory:" 10 60 "$HOME/Videos" 3>&1 1>&2 2>&3)

if [ $? -ne 0 ]; then exit; fi

# Create directory if it doesn't exist
mkdir -p "$SAVEDIR"

# Ask for the Resolution
RES=$(whiptail --title "QCOW2 Compressor" --inputbox "Enter resolution (WidthxHeight):" 10 60 "1920x1080" 3>&1 1>&2 2>&3)

if [ $? -ne 0 ]; then exit; fi

# Construct the full path
FULLPATH="$SAVEDIR/$FILENAME.mp4"

# Execute wf-recorder
qemu-img convert -c -O qcow2 $SAVEDIR/$FILENAME.qcow2 $SAVEDIR/$FILENAME2.qcow2
