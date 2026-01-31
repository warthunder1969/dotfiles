#!/bin/bash
# Script to Activate wf-recorder. Should work for most Debian or Ubuntu based systems
# Version 1.0

## Variables
TODAY=$(date +%Y-%m-%d)


wf-recorder -a width=1920,height=1080 -f $HOME/recording_$TODAY.mp4