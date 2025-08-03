#!/bin/bash

# --- Check and Install Dependencies ---
# This script will check if the required packages are installed and
# will install them if they are not.

# Function to check and install a package
check_and_install() {
    PACKAGE_NAME=$1
    if ! dpkg -s "$PACKAGE_NAME" >/dev/null 2>&1; then
        echo "The package '$PACKAGE_NAME' is not installed. Installing now..."
        sudo apt-get update
        sudo apt-get install -y "$PACKAGE_NAME"
    else
        echo "The package '$PACKAGE_NAME' is already installed."
    fi
}

echo "--- Starting dependency configuration ---"

# Required for 'split_pdf.sh'
# This script uses 'pdftk' to split a PDF into chapters based on bookmarks.
# Note: 'pdftk' is not available in standard Ubuntu repositories on some newer versions.
# A PPA might be required to install it.
check_and_install pdftk

# Required for 'convert_pdfs.sh'
# This script uses 'pdftotext' to convert PDF files to TXT.
# The 'pdftotext' command is part of the 'poppler-utils' package.
check_and_install poppler-utils

# Required for 'converter.sh'
# This script uses 'text2wave' to convert text files to WAV audio.
# The 'text2wave' command is part of the 'festival' speech synthesis system.
check_and_install festival

# Required for 'wave2opus.sh'
# This script uses 'ffmpeg' to convert WAV audio files to Opus format.
check_and_install ffmpeg

echo "--- Dependency configuration finished ---"
