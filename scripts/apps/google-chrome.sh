#!/bin/bash

# Script to install Google Chrome on Debian-based systems

echo "Starting Google Chrome installation..."

# 1. Download the Google Chrome .deb package
echo "Downloading Google Chrome .deb package..."
wget -q -O google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

if [ $? -ne 0 ]; then
    echo "Error: Failed to download Google Chrome. Exiting."
    exit 1
fi
echo "Download complete."

# 2. Install the package using dpkg
echo "Installing Google Chrome..."
sudo dpkg -i google-chrome-stable_current_amd64.deb

if [ $? -ne 0 ]; then
    echo "Warning: dpkg installation failed, attempting to fix broken dependencies."
    # 3. Fix any broken dependencies
    sudo apt --fix-broken install -y
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fix broken dependencies. Please try to run 'sudo apt --fix-broken install' manually."
        exit 1
    fi
    echo "Dependencies fixed. Retrying installation of Google Chrome..."
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    if [ $? -ne 0 ]; then
        echo "Error: Google Chrome installation still failed after fixing dependencies. Exiting."
        exit 1
    fi
fi

echo "Google Chrome installed successfully!"

# Clean up the downloaded .deb file
echo "Cleaning up downloaded package..."
rm google-chrome-stable_current_amd64.deb
echo "Cleanup complete."

echo "You can now launch Google Chrome from your applications menu or by typing 'google-chrome' in the terminal."