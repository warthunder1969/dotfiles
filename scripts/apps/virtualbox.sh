#!/bin/bash
# Display menu options

echo "How do you want to install Virutalbox?"
echo "1. Repository Version"
echo "2. Oracle Repository"
echo "3. Raw Download"
echo "4. Exit"

# Read user input
read -p "Enter your choice: " choice

# Process user choice
case $choice in
    1)
        echo "You chose Option 1"
        sudo apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso -y
        ;;
    2)
        echo "You chose Option 2"
# Get the codename of the current distribution
        DISTRO_CODENAME=$(lsb_release -cs)
# Define the repository you want to add
        REPO_URL="deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian ${DISTRO_CODENAME} contrib"
        

        
        echo "$REPO_URL" | sudo tee /etc/apt/sources.list.d/virtualbox.list
# Get Oracle public key for verifying the signatures
        wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor


wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor

# Update the package list
        sudo apt update
        sudo apt-get install virtualbox-7.1
        ;;
    3)
        echo "You chose Option 3"
        wget https://download.virtualbox.org/virtualbox/7.1.8/virtualbox-7.1_7.1.8-168469~Debian~bookworm_amd64.deb
dkpg -i virtualbox-*.deb
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please try again."
        ;;
#warn the user to reboot due to dkms modules
echo "you will need to reboot"
esac 










