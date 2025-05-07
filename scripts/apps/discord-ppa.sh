#URL: https://discordapp.com/api/download?platform=linux&format=deb
#Installation
#source: https://blog.javinator9889.com/discord-ppa-keep-it-up-to-date-on-linux-easily/
#Firstly, we need to import the GPG repository keys. In a previous version 
#this was done using the apt-key command, but as for January 2021 it’s 
#deprecated and the recommended way has changed and it’s a bit larger:

sudo -E gpg --no-default-keyring --keyring=/usr/share/keyrings/javinator9889-ppa-keyring.gpg --keyserver keyserver.ubuntu.com --recv-keys 08633B4AAAEB49FC

#Then, add the repository to your sources.list as follows:


# Stable repository
sudo tee /etc/apt/sources.list.d/javinator9889-ppa.list <<< "deb [arch=amd64 signed-by=/usr/share/keyrings/javinator9889-ppa-keyring.gpg] https://ppa.javinator9889.com all main"

# Beta repository
#sudo tee /etc/apt/sources.list.d/javinator9889-ppa.list <<< "deb [arch=amd64 signed-by=/usr/share/keyrings/javinator9889-ppa-keyring.gpg] https://ppa.javinator9889.com public-beta main"

# Canary repository
#sudo tee /etc/apt/sources.list.d/javinator9889-ppa.list <<< "deb [arch=amd64 signed-by=/usr/share/keyrings/javinator9889-ppa-keyring.gpg] https://ppa.javinator9889.com canary main"

#Notice that all the commands above will overwrite the file if they are all executed. You must choice an option suitable for your needs (usually the all repository) and do the installation. The same applies for the commands below, as you should only use the Discord version you need.

sudo apt update && sudo apt install discord

# If using public beta, install as follows:
#sudo apt install discord-ptb

# If using canary, install as follows:
#sudo apt install discord-canary

#You can browse the repository at the following URL: https://ppa.javinator9889.com/ and the GitHub repo at: https://github.com/Javinator9889/discord-ppa
#Uninstalling Discord and repository

#If you would like to remove Discord from your computer and remove the repository from your sources.list, run the following commands:
sudo apt remove discord
# If using public beta, uninstall as follows
#sudo apt remove discord-ptb

# Remove the repository from the lists
#sudo rm /etc/apt/sources.list.d/javinator9889-ppa.list

# Finally, remove the key if you want not to trust it anymore
#sudo -E gpg --no-default-keyring --keyring=/usr/share/keyrings/javinator9889-ppa-keyring.gpg --delete-keys 08633B4AAAEB49FC
