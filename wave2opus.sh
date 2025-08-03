#!/bin/bash

# Loop para processar todos os arquivos com a extensão .wav na pasta
for file in *.wav; do
    # Extrai o nome do arquivo sem a extensão (ex: de "audio.wav" para "audio")
    base_name="${file%.*}"
    
    echo "Convertendo '${file}' para '${base_name}.opus'..."

    # Converte o arquivo .wav para .opus usando o ffmpeg
    # O "&&" garante que o arquivo .wav só será apagado se a conversão for bem-sucedida
    ffmpeg -i "${file}" "${base_name}.opus" && rm "${file}"
    
    echo "Arquivo '${file}' apagado."
done

echo "Conversão de todos os arquivos concluída!"
