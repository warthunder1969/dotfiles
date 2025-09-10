#!/bin/bash
# Installing google chrome via APT
# Setup the Google signer and repo

cat << EOL >> /etc/apt/sources.list.d/google-chrome.list
### THIS FILE IS AUTOMATICALLY CONFIGURED ###
# You may comment out this entry, but any other modifications may be lost.
deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main
EOL

 sudo /usr/bin/wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/google.gpg >/dev/null


# Install
sudo apt update
sudo apt install google-chrome-stable





