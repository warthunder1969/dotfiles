#!/bin/bash
# init

#Check for Package updates
sudo apt-get update
#Install the utility and run it
sudo apt-get install mintupgrade
sudo mintupgrade
#Remove it and clean up
sudo apt-get remove mintupgrade
sudo apt-get autoremove
