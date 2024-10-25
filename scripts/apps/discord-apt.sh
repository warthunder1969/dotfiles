sudo touch /etc/apt/sources.list.d/discord.list
sudo tee "deb https://palfrey.github.io/discord-apt/debian/ ./" >> /etc/apt/sources.list.d/discord.list  
cd /etc/apt/trusted.gpg.d
sudo wget https://palfrey.github.io/discord-apt/discord-apt.gpg.asc

    sudo apt-get update
    sudo apt-get install discord

