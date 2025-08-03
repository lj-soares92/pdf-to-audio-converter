#!/bin/bash

# Loop to process all files with the .txt extension in the folder
for file in *.txt; do
    # Extracts the filename without the extension (e.g., from "File01.txt" to "File01")
    base_name="${file%.*}"
    
    echo "Converting '${file}' to '${base_name}.wav'..."

    # Converts the text to a .wav file
    text2wave "${file}" -o "${base_name}.wav"
done

echo "Conversion of all files completed!"
