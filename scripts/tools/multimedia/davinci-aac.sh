#!/bin/bash
set -e
origdir="./original"
shopt -s extglob nullglob
if [ ! -d "$origdir" ];
then
echo "Creating $origdir directory."
mkdir "$origdir"
fi
for vid in *.mp4; do
noext="${vid%.mp4}"
ffmpeg -i "$vid" -codec:a libmp3lame -qscale:a 320 "${noext// /_}.mp3"
mv "$vid" "$origdir"
done
for vid in *mkv; do
noext="${vid%.mkv}"
ffmpeg -i "$vid" -codec:a libmp3lame -qscale:a 320 "${noext// /_}.mp3"
mv "$vid" "$origdir"
done
for vid in *webm; do
noext="${vid%.webm}"
ffmpeg -i "$vid" -codec:a libmp3lame -qscale:a 320 "${noext// /_}.mp3"
mv "$vid" "$origdir"
done
