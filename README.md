## PDF to Audio Converter
This project is a set of Bash scripts designed to automate the conversion of a book in PDF format into a series of audio files, with each audio file representing a chapter of the book.

The workflow includes splitting the PDF into individual chapters (based on bookmarks), converting each chapter to text, transforming that text into audio in WAV format, and finally, converting the audio to the Opus format, which is more efficient in terms of compression.

## Prerequisites
For the scripts to work correctly, you need to have the following dependencies installed on your Linux (Ubuntu) system:

* **`pdftk`**: Used to split the PDF into chapters.
* **`poppler-utils`**: Provides the `pdftotext` command to convert PDFs to text files.
* **`festival`**: A speech synthesis system that includes the `text2wave` command to convert text to WAV audio.
* **`ffmpeg`**: A powerful tool for manipulating audio and video files, used here to convert WAV files to the Opus format.

## How to Use
The complete process is executed through a single main script, init.sh, which manages the sequence of all tasks. You must provide the name of your PDF file as a parameter to this script.

## Step 1: Prepare the Book
Place your PDF file in the same folder as the scripts.

Ensure the PDF has level 1 bookmarks so the split_pdf.sh script can correctly identify the chapters.

## Step 2: Grant Execution Permission to the Script
Before running the init.sh script for the first time, you need to grant it execution permission. Open the terminal in the project folder and use the following command:

chmod +x init.sh

## Step 3: Run the Conversion Process
Now you can run the init.sh script, passing the name of your PDF file as an argument.

./init.sh your_book_name.pdf

The init.sh script will then execute the following tasks in sequence:

Check for and install the necessary dependencies (if not already installed).

Split the PDF file into separate files, one for each chapter.

Convert each chapter's PDF file to text (.txt).

Convert each text file to audio in WAV format (.wav).

Convert the WAV audio to the Opus format (.opus) and then remove the WAV files to clean up the folder.

After successful execution, you will have a series of Opus audio files in the same folder, one for each chapter of your book.

Author: Lucas de Jesus Soares
License: MIT
