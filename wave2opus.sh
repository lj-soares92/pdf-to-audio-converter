#!/bin/bash

# Loop to process all files with the .wav extension in the folder
for file in *.wav; do
    # Extracts the filename without the extension (e.g., from "audio.wav" to "audio")
    base_name="${file%.*}"
    
    echo "Converting '${file}' to '${base_name}.opus'..."

    # Converts the .wav file to .opus using ffmpeg
    # The "&&" ensures that the .wav file will only be deleted if the conversion is successful
    ffmpeg -i "${file}" "${base_name}.opus" && rm "${file}"
    
    echo "File '${file}' deleted."
done

echo "Conversion of all files completed!"
