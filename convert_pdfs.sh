#!/bin/bash

# Script to convert all PDF files in a folder to TXT.
# It requires the 'poppler-utils' package (which contains pdftotext) to be installed.

# Loops through all files that end with the .pdf extension
for chapter in *.pdf
do
  # Converts each file to TXT format
  # The new .txt file will have the same name as the original
  pdftotext "$chapter"
done
