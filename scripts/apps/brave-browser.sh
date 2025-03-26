#!/bin/bash

# Display menu options
echo "What version do you want?:"
echo "1. Deb Package"
echo "2. Flatpak"
echo "3. Exit"

# Read user input
read -p "Enter your choice: " choice

# Process user choice
case $choice in
    1)
        echo "You chose Deb Package"
        sudo apt install curl

        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

        sudo apt update
        sudo apt install brave-browser
        echo "Package Installed"
        ;;
    2)
        echo "You chose Flatpak"
        sudo apt install flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub com.brave.Browser
        echo "Package Installed"
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please try again."
        ;;

esac
