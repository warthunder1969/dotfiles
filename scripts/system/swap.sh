#!/bin/bash
#source: https://www.howtoforge.com/tutorial/linux-swappiness/
#source: https://community.linuxmint.com/tutorial/view/998

ram=$(free -h | awk '/Mem/ { print $2 }')

# The rule is: 
#1GB RAM or more: set the swappiness to 10
#Less then 1GB: set the swappiness to 1

echo -n "Current Swapiness: " 
cat /proc/sys/vm/swappiness
echo "Current RAM: $ram"



