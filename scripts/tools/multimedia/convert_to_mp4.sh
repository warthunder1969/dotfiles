#! /bin/bash
# Folder to convert
DIR=/home/$USER/Videos/project_files/convert_to_mkv
DIR2=/home/$USER/Videos/project_files/upload
#FILES=$(ls *.mkv)

EXT=mp4
EXT2=mov
#echo $DIR
for FILE in ${DIR}/*.$EXT2 ; do
#    [ -f "$i" ] || break
     ffmpeg -i "$FILE" -vf yadif -codec:v libx264 -crf 1 -bf 2 -flags +cgop -pix_fmt yuv420p -codec:a aac -strict -2 -b:a 384k -r:a 48000 -movflags faststart "${FILE%.$EXT2}".$EXT
     mv -i ${DIR}/*.$EXT ${DIR2}
     #mv -i "${FILE%.$EXT}".$EXT2 ${DIR2}/"${FILE%.$EXT}".$EXT2
done
