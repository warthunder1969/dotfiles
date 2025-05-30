#!/bin/sh -e

if [ ! -d "$1" ]
then
    echo "Error - destination $1 must exist and be a directory" >&2
    exit 2
fi

DESTDIR="$1"
shift

convert()
{
    BASENAME="${1%.*}"
    BASENAME="${BASENAME##*/}"
    EXT="${1##*.}"

    echo
    echo "Converting $BASENAME.$EXT to $2/$BASENAME.mov:"

    ffmpeg -i "$1" -c:v copy -c:a pcm_s16le "$2/$BASENAME.mov"
}

for file in "$@"
do
    convert "$file" "$DESTDIR"
done