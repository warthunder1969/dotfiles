#!/bin/bash
#Transcoding MP4's for use with DaVinci Resolve on Linux
#source:https://www.reddit.com/r/davinciresolve/comments/1bl1159/smaller_lossless_dnxhr_hqx_alternative_for_mp4/

#RAW COMMAND: 
#ffmpeg -i "file" -c:v mpeg2video -vf "fps=30" -q:v 1 -c:a pcm_s16le "file.mov"

notify-send "Encoding Started"


mkdir transcoded; 

for i in *.mkv;
    do name=`echo "$i" | cut -d'.' -f1`
    echo "$name"
    ffmpeg -i "$i" -c:v mpeg2video -vf "fps=30" -q:v 1 -c:a pcm_s16le "transcoded/${name}.mov"
done

for i in *.MKV;
    do name=`echo "$i" | cut -d'.' -f1`
    echo "$name"
    ffmpeg -i "$i" -c:v mpeg2video -vf "fps=30" -q:v 1 -c:a pcm_s16le "transcoded/${name}.mov"
done

notify-send "Script finished" "The process has completed successfully."
