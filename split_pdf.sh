#!/bin/bash

# --- Prerequisites ---
# Install pdftk if you don't have it yet:
# sudo apt-get update
# sudo apt-get install pdftk

# --- Book Settings ---
# REPLACE 'book_name.pdf' with the name of your PDF file.
INPUT_PDF="$1"

# The output directory will be the current directory (represented by '.')
OUTPUT_DIR="."

# Control variable to track errors
ERROR_FOUND=0

# --- Processing ---
# Checks if the input file exists.
if [ ! -f "$INPUT_PDF" ]; then
    echo "Error: The file '$INPUT_PDF' was not found."
    echo "Please verify that the filename is correct and that it is in the current directory."
    exit 1
fi

echo "Extracting level 1 bookmarks from '$INPUT_PDF'..."

# 1. Extracts all bookmark data from the PDF.
pdftk "$INPUT_PDF" dump_data output - > bookmarks_raw.txt

# 2. Uses 'awk' to filter only level 1 bookmarks and
# format the data so we can read it easily.
awk '
    /^BookmarkBegin/ { if (level == 1) print title "|" page; level=0; title=""; page="" }
    /^BookmarkLevel: 1/ { level=1 }
    /^BookmarkTitle:/ { title=$0; sub(/BookmarkTitle: /, "", title); }
    /^BookmarkPageNumber:/ { page=$2 }
    END { if (level == 1) print title "|" page; }
' bookmarks_raw.txt > bookmarks_parsed.txt

# 3. Reads the processed file to create the title and page arrays
mapfile -t chapters < bookmarks_parsed.txt

# 4. Gets the total number of pages in the book for the last chapter
total_pages=$(pdftk "$INPUT_PDF" dump_data | grep NumberOfPages | awk '{print $2}')
num_chapters=${#chapters[@]}

# 5. Iterates over the chapters to split the PDF.
for ((i = 0; i < num_chapters; i++)); do
    # Formats the counter with a leading zero (e.g., 01, 02, ..., 10).
    counter=$((i + 1))
    formatted_counter=$(printf "%02d" "$counter")

    # Extracts the title and starting page
    title=$(echo "${chapters[i]}" | cut -d'|' -f1)
    cleaned_title=$(echo "$title" | sed 's/[^a-zA-Z0-9_ -]/_/g' | sed 's/ /_/g')
    starting_page=$(echo "${chapters[i]}" | cut -d'|' -f2)

    # Determines the ending page of the chapter
    if ((i + 1 < num_chapters)); then
        ending_page=$(echo "${chapters[i + 1]}" | cut -d'|' -f2 | cut -d' ' -f1)
        ending_page=$((ending_page - 1))
    else
        ending_page=$total_pages
    fi

    INTERVAL="$starting_page-$ending_page"
    OUTPUT_FILE="$OUTPUT_DIR/${formatted_counter}_${cleaned_title}.pdf"

    echo "Splitting chapter '$cleaned_title' (pages $INTERVAL) and saving as '$formatted_counter_${cleaned_title}.pdf'..."

    pdftk "$INPUT_PDF" cat "$INTERVAL" output "$OUTPUT_FILE"

    if [ $? -eq 0 ]; then
        echo "✓ Chapter created successfully."
    else
        echo "✗ Error creating chapter '$cleaned_title'."
        ERROR_FOUND=1
    fi
done

# Cleans up temporary files
rm bookmarks_raw.txt bookmarks_parsed.txt

echo "---"

# 6. Checks for any errors, and if none, removes the original file.
if [ "$ERROR_FOUND" -eq 0 ]; then
    echo "Process completed! Chapters were created successfully."
    echo "Removing the original file '$INPUT_PDF'..."
    rm "$INPUT_PDF"
    echo "The original file has been removed."
else
    echo "Process completed with errors. The original file '$INPUT_PDF' will not be removed."
fi
