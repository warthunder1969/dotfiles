#!/bin/bash

#checks to see if minecraft is installed
nm="dpkg -l | grep minecraft"
nm2="flatpak list | grep minecraft"
#Checking apt
if [ nm=0 ]; then
  echo "You don't have Minecraft...exiting"
exit 0 
fi
#Checking Flatpaks
if [ nm2=0 ]; then
  echo "You don't have Minecraft...exiting"
exit 0 
fi

#Download new mod files from Nate
cd $HOME/Downloads/
git clone https://github.com/NatePick/NatePick-s-Lounge-Modlist.git
cd NatePick-s-Lounge-Modlist

#clear out old mods
rm $HOME/.minecraft/mods/*
mv $HOME/Downloads/NatePick-s-Lounge-Modlist/Client/* $HOME/.minecraft/mods/
cd ..

rm -rf NatePick-s-Lounge-Modlist
