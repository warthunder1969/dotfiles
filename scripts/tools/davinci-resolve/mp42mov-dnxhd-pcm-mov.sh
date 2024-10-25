#!/bin/bash
#SOURCE:https://www.reddit.com/r/davinciresolve/comments/15lq319/linux_format_converter_script/
#RAW COMMAND
#ffmpeg -i input.mp4 -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a pcm_s16le -f mov output.mov 


if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/folder"
    exit 1
fi

input_folder="$1"
output_folder="$input_folder/Converted"

if [ ! -d "$output_folder" ]; then
    mkdir "$output_folder"
fi

for video_file in "$input_folder"/*.mp4; do
    if [ -f "$video_file" ]; then
        filename=$(basename "$video_file")
        output_file="$output_folder/${filename%.mp4}.mov"
        
        ffmpeg -i "$video_file" -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a pcm_s16le -f mov "$output_file"
        
        echo "Converted: $filename -> ${filename%.mp4}.mov"
    fi
done

echo "Conversion completed."
