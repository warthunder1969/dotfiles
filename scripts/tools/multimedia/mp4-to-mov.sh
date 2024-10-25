#!/bin/sh


#RAW COMMAND
#ffmpeg -i $FILE.mp4 -c:v prores_ks -profile:v 3 -c:a pcm_s16be $FILE.mov

for i in *.mp4; do ffmpeg -i "$i" -c:v prores_ks -profile:v 3 -c:a pcm_s16be "${i%.*}.mov"; done
