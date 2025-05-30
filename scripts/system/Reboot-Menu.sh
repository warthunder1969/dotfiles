#!/bin/bash
echo "Options Available in Grub:"
sudo awk -F\' '$1=="menuentry " || $1=="submenu " {print i++ " : " $2}; /\smenuentry / {print "\t" i-1">"j++ " : " $2};' /boot/grub/grub.cfg

# Display menu options
echo "Pick an Option, or press enter to quit:"

# Read user input
read -p "Enter your choice: " choice


# Process user choice
if [ -z "$choice" ]; then
  echo "Exiting..."
  exit 0
else
  sudo grub-reboot $choice
  read -n 1 -s -p "Press any key to reboot..."
  sudo reboot
fi

esac
