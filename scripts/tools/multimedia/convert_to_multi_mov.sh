#! /bin/bash
# Folder to convert
DIR=/home/$USER/Videos/project_files/convert_to_mov
DIR2=/home/$USER/Videos/project_files
#FILES=$(ls *.mkv)

EXT=mkv
EXT2=mov
#echo $DIR
for FILE in ${DIR}/*.$EXT ; do
#    [ -f "$i" ] || break
     ffmpeg -i "$FILE"  -map 0:0 -map 0:1 -map 0:2? -vcodec dnxhd -acodec:0 pcm_s16le -acodec:1 pcm_s16le -s 1920x1080 -r 30000/1001 -b:v 36M -pix_fmt yuv422p "${FILE%.$EXT}".$EXT2
     # -map 0:0 -map 0:1 -map 0:2 -vcodec dnxhd -acodec:0 pcm_s16le -acodec:1 pcm_s16le -s 1920x1080 -r 30000/1001 -b:v 36M -pix_fmt yuv422p -f mov
     #echo $FILE
     mv -i ${DIR}/*.$EXT2 ${DIR2}
     #mv -i "${FILE%.$EXT}".$EXT2 ${DIR2}/"${FILE%.$EXT}".$EXT2
done
