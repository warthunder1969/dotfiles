#!/bin/bash

notify-send "Merge Started"

for f in *.MOV; do echo "file '$f'" >> input.txt; done

ffmpeg -f concat -safe 0 -i input.txt -c:v copy /home/war/Videos/output.mov

notify-send "Merge finished" 
