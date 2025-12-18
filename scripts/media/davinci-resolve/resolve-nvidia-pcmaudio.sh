#! /bin/bash
#!/bin/bash
#Transcoding MP4's for use with DaVinci Resolve on Linux
#source:https://forum.blackmagicdesign.com/viewtopic.php?f=33&t=188985

notify-send "Encoding Started" "The process has begun."

for f in *.mp4;
do
    ffmpeg -i "$f" -c:v copy -c:a pcm_s32le "${f%.mp4}"_my-custom-suffix.mp4
done

for f in *.mkv;
do
    ffmpeg -i "$f" -c:v copy -c:a pcm_s32le "${f%.mkv}"_my-custom-suffix.mkv
done


notify-send "Script finished" "The process has completed successfully."
