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
        sudo apt install -y wget apt-transport-https
‍
        sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
‍
        echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list

        sudo apt update

        sudo apt install element-desktop
        echo "Package Installed"
        ;;
    2)
        echo "You chose Flatpak"
        sudo apt install flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub im.riot.Riot
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
