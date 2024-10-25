ffmpeg -i $FILE.mp4 -c:v prores_ks -profile:v 3 -c:a pcm_s16be $FILE.mov
