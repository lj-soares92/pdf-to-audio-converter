#!/bin/bash

# --- Initialization Script for the PDF to Audio Converter ---
# This script executes the complete sequence of scripts to convert a PDF
# into a series of Opus audio files, one for each chapter.

# Checks if the filename was provided as a parameter
if [ -z "$1" ]; then
    echo "Error: Please provide the PDF filename as an argument."
    echo "Usage: ./init.sh <your_file_name.pdf>"
    exit 1
fi

INPUT_PDF="$1"

# 1. Configure the environment (install dependencies)
echo "Step 1/5: Configuring the environment and installing dependencies..."
./config.sh
if [ $? -ne 0 ]; then
    echo "Error in configuration. Check if 'config.sh' was executed correctly."
    exit 1
fi

# 2. Split the PDF into individual chapters
echo "Step 2/5: Splitting the PDF into chapters..."
# The 'split_pdf.sh' script is now called with the filename as a parameter
./split_pdf.sh "$INPUT_PDF"
if [ $? -ne 0 ]; then
    echo "Error splitting the PDF. Check the input file and the 'split_pdf.sh' script."
    exit 1
fi

# 3. Convert the chapter PDFs to text
echo "Step 3/5: Converting PDFs to text..."
./convert_pdfs.sh
if [ $? -ne 0 ]; then
    echo "Error converting PDFs to text. Check the 'convert_pdfs.sh' script."
    exit 1
fi

# 4. Convert the text files to WAV audio
echo "Step 4/5: Converting text to WAV audio..."
./converter.sh
if [ $? -ne 0 ]; then
    echo "Error converting text to WAV audio. Check the 'converter.sh' script."
    exit 1
fi

# 5. Convert WAV audio to Opus and remove temporary files
echo "Step 5/5: Converting WAV to Opus and cleaning up temporary files..."
./wave2opus.sh
if [ $? -ne 0 ]; then
    echo "Error converting WAV to Opus. Check the 'wave2opus.sh' script."
    exit 1
fi

echo "--- Conversion process completed successfully! ---"
echo "The Opus audio files are ready in the current folder."
