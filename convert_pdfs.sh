#!/bin/bash

# Script para converter todos os arquivos PDF em uma pasta para TXT.
# Ele requer o pacote 'poppler-utils' (que contém o pdftotext) instalado.

# Percorre todos os arquivos que terminam com a extensão .pdf
for chapter in *.pdf
do
  # Converte cada arquivo para o formato TXT
  # O novo arquivo .txt terá o mesmo nome do original
  pdftotext "$chapter"
done
