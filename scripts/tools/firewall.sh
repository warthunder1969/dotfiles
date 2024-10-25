#!/bin/bash
# init

echo "****Optimizing Firewall and Security****"

#setting up firewall	    
sudo apt install ufw

sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

pause 'Press [Enter] key to continue...'
