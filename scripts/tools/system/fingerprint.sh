#!/bin/bash
#To enable the fingerprint scanner
#Source: https://hackeradam.com/enable-fingerprint-authentication-on-popos/
#Source:https://forums.linuxmint.com/viewtopic.php?t=384183
#Update the apt:

sudo apt update

#Install fprintd and the pam lib for fprintd:

sudo apt-get install fprintd libpam-fprintd

#Enroll the finger using fprintd:

fprintd-enroll

#Update PAM to use the fingerprint scanner and check Finger Print Authentication :
sudo pam-auth-update --enable fprintd
