#! /bin/bash
# Folder to convert
DIR=/home/$USER/Videos/project_files/convert_to_mkv
DIR2=/home/$USER/Videos/project_files/upload
#FILES=$(ls *.mkv)

EXT=mkv
EXT2=mov
#echo $DIR
for FILE in ${DIR}/*.$EXT2 ; do
#    [ -f "$i" ] || break
     ffmpeg -i "$FILE" -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k -pix_fmt yuv420p "${FILE%.$EXT2}".$EXT
     mv -i ${DIR}/*.$EXT ${DIR2}
     #mv -i "${FILE%.$EXT}".$EXT2 ${DIR2}/"${FILE%.$EXT}".$EXT2
done
