#!/bin/bash

# Loop para processar todos os arquivos com a extensão .txt na pasta
for file in *.txt; do
    # Extrai o nome do arquivo sem a extensão (ex: de "File01.txt" para "File01")
    base_name="${file%.*}"
    
    echo "Convertendo '${file}' para '${base_name}.wav'..."

    # Converte o texto para um arquivo .wav
    text2wave "${file}" -o "${base_name}.wav"
done

echo "Conversão de todos os arquivos concluída!"
