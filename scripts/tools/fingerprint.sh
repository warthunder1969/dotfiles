#!/bin/bash
#To enable the fingerprint scanner
#Update the apt:

sudo apt update

#Install fprintd and the pam lib for fprintd:

sudo apt-get install fprintd libpam-fprintd

#Enroll the finger using fprintd:

fprintd-enroll

#Update PAM to use the fingerprint scanner and check Finger Print Authentication :
sudo pam-auth-update
