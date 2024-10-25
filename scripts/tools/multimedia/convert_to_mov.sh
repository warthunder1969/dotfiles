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
     ffmpeg -i "$FILE" -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a pcm_s16le "${FILE%.$EXT}".$EXT2
     #echo $FILE
     mv -i ${DIR}/*.$EXT2 ${DIR2}
     #mv -i "${FILE%.$EXT}".$EXT2 ${DIR2}/"${FILE%.$EXT}".$EXT2
done
