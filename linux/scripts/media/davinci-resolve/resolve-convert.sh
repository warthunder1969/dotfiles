#!/bin/bash
#Transcoding MP4's for use with DaVinci Resolve on Linux
#source:https://www.reddit.com/r/davinciresolve/comments/1bl1159/smaller_lossless_dnxhr_hqx_alternative_for_mp4/

# For MP4 files: 

notify-send "Encoding Started" "The process has begun."

mkdir transcoded; 

for i in *.{mp4, MP4, mkv, MKV, m4a, M4A, mts, MTS}
    do name=`echo "$i" | cut -d'.' -f1`
    echo "$name"
    ffmpeg -i "$i" -c:v mpeg2video -vf "fps=30" -q:v 1 -c:a pcm_s16le "transcoded/${name}.mov"
done
