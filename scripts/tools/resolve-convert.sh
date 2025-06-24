#!/bin/bash
#Transcoding for use with DaVinci Resolve on Linux
#source:https://www.reddit.com/r/davinciresolve/comments/1bl1159/smaller_lossless_dnxhr_hqx_alternative_for_mp4/

notify-send "Encoding Started"

# For MP4 files: 
mkdir transcoded; 

for i in *.{mkv,MKV,mp4,MP4};
    do name=`echo "$i" | cut -d'.' -f1`
    echo "$name"
    ffmpeg -i "$i" -c:v mpeg2video -vf "fps=30" -q:v 1 -c:a pcm_s16le "transcoded/${name}.mov"
done

notify-send "Script finished" "The process has completed successfully."
