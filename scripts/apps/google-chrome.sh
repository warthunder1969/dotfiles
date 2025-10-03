#!/bin/bash

# Google Chrome Install Script
# Version: 1.0
# This is for Installing google chrome via APT pkg manager

# Purge all existing Google Files
sudo rm /usr/share/keyrings/google-chrome.gpg
sudo rm /etc/apt/sources.list.d/google-chrome.list
sudo rm /etc/apt/trusted.gpg.d/google.gpg
sudo rm /etc/apt/trusted.gpg.d/google-chrome.gpg

# Setup the Google signer and repo
curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Install
sudo apt update
sudo apt install google-chrome-stable





