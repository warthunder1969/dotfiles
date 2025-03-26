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
        sudo apt update
        sudo apt install -y wget gnupg lsb-release apt-transport-https ca-certificates

        distro=$(if echo " una bookworm vanessa focal jammy bullseye vera uma " | grep -q " $(lsb_release -sc) "; then lsb_release -sc; else echo focal; fi)

        wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg

        sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

        sudo apt install librewolf -y
        echo "Package Installed"
        ;;
    2)
        echo "You chose Flatpak"
        sudo apt install flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub io.gitlab.librewolf-community
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
