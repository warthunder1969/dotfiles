#!/bin/bash

# Display menu options
echo "What version do you want?:"
echo "1. Deb Package via Discord.com"
echo "2. Tarball via Discord.com"
echo "3. palfrey's PPA"
echo "4. Flatpak"
echo "5. Exit"

# Read user input
read -p "Enter your choice: " choice

# Process user choice
case $choice in
    1)
        echo "You chose Deb Package"
        wget -c --show-progress https://discord.com/api/download?platform=linux
        cat wgetlog*
        mv download?platform=linux discord.deb
        sudo apt install ./discord.deb
        rm wgetlog*
        rm discord.deb

        echo "Package Installed"
        ;;
    2)
        echo "You chose Tarball Package"
        wget -c --show-progress https://discord.com/api/download?platform=linux&format=tar.gz
        cat wgetlog*
        mv download?platform=linux discord.tar.gz
        mkdir ~/Applications/Discord
        tar -xzf discord.tar.gz -C ~/Applications/Discord
        mv download?platform=linux discord.deb
        rm wgetlog*
        rm discord.tar.gz

        echo "Package Installed"
        ;;

    3)
        echo "You chose Deb Package via palfrey's PPA"
        sudo touch /etc/apt/sources.list.d/discord.list
        sudo tee "deb https://palfrey.github.io/discord-apt/debian/ ./" >> /etc/apt/sources.list.d/discord.list
        cd /etc/apt/trusted.gpg.d
        sudo wget https://palfrey.github.io/discord-apt/discord-apt.gpg.asc

        sudo apt-get update
        sudo apt-get install discord
        cd ~
        echo "Package Installed"
        ;;
    4)
        echo "You chose Flatpak"
        sudo apt install flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub com.discordapp.Discord
        echo "Package Installed"
        ;;
    5)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please try again."
        ;;

esac
