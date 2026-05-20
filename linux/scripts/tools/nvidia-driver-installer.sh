#!/bin/bash

# Install dependencies if not present
dpkg -l | grep -qw nvidia-detect || sudo apt install -yyq nvidia-detect
dpkg -l | grep -qw dialog || sudo apt install -yyq dialog

# 1. Detect NVIDIA GPU and recommended driver
echo "Detecting NVIDIA GPU..."
GPU_INFO=$(nvidia-detect 2>/dev/null)
if [ -z "$GPU_INFO" ]; then
    dialog --msgbox "No NVIDIA GPU detected or nvidia-detect failed." 10 40
    clear
    exit 1
fi

# Extract recommended package (example logic, may vary by distro)
# nvidia-detect output is often verbose, so you may need to parse it
RECOMMENDED_DRIVER=$(echo "$GPU_INFO" | grep -oP 'Recommended package: \K.*' || echo "nvidia-driver")

dialog --msgbox "Detected GPU. Recommended driver: $RECOMMENDED_DRIVER" 10 40

# 2. Confirm installation via TUI
dialog --yesno "Install $RECOMMENDED_DRIVER?" 10 40
if [ $? -eq 0 ]; then
    dialog --infobox "Installing $RECOMMENDED_DRIVER... Please wait." 10 40
    
    # 3. Install the driver
    # Note: Replace with your distro's package manager command
    sudo apt-get install -y $RECOMMENDED_DRIVER
    
    if [ $? -eq 0 ]; then
        dialog --msgbox "Installation successful. Please reboot." 10 40
    else
        dialog --msgbox "Installation failed." 10 40
    fi
else
    dialog --msgbox "Installation cancelled." 10 40
fi   
