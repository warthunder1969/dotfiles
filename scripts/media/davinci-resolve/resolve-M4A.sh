#!/bin/bash
#Transcoding MP4's for use with DaVinci Resolve on Linux
#source:https://www.reddit.com/r/davinciresolve/comments/1bl1159/smaller_lossless_dnxhr_hqx_alternative_for_mp4/

#RAW COMMAND: 
#ffmpeg -i show.m4a -c:a libmp3lame -q:a 8 output.mp3

notify-send "Encoding Started" "The process has begun."

mkdir transcoded; 

for i in *.m4a;
    do name=`echo "$i" | cut -d'.' -f1`
    echo "$name"
    ffmpeg -i "$i" -c:a libmp3lame -q:a 8 "transcoded/${name}.mp3"
done

for i in *.M4A;
    do name=`echo "$i" | cut -d'.' -f1`
    echo "$name"
     ffmpeg -i "$i" -c:a libmp3lame -q:a 8 "transcoded/${name}.mp3"
done

notify-send "Script finished" "The process has completed successfully."
