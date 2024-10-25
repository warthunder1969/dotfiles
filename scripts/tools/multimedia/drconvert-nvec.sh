#!/bin/sh

#Raw Command
#ffmpeg -i 'FILE.mkv' -c:v copy -c:a pcm_s16le 'FILE.mov'



for i in *.mkv; do
    ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i "$i" -c:v copy -c:a pcm_s16le "${i%.*}.mov"
done
