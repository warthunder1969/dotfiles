#!/bin/bash

# chksys -- A very sinple script to check on system resources.
# By Joe Collins. (www.ezeelinux.com GNU/General Public License version 2.0)

clear
echo "Memory Usage:"
/usr/bin/free -h

echo $'\n'$"Disk Usage:"
/bin/df -h /dev/sd[a-z][1-9] 2>/dev/null

echo $'\n'$"Uptime:"
/usr/bin/uptime

exit
