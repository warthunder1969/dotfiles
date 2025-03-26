#!/bin/sh
#Source:https://bugs.launchpad.net/hwe-next/+bug/1786574
case $1 in
  pre)
    modprobe -r i2c-i801
    ;;
  post)
    modprobe i2c-i801
    ;;
esac
