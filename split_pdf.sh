#!/bin/bash

# --- Pré-requisitos ---
# Instale o pdftk se ainda não o tiver:
# sudo apt-get update
# sudo apt-get install pdftk

# --- Configurações do Livro ---
# SUBSTITUA 'book_name.pdf' pelo nome do seu arquivo PDF.
INPUT_PDF="$1"

# O diretório de saída será o diretório atual (representado por '.')
OUTPUT_DIR="."

# Variável de controle para rastrear erros
ERRO_ENCONTRADO=0

# --- Processamento ---
# Verifica se o arquivo de entrada existe.
if [ ! -f "$INPUT_PDF" ]; then
    echo "Erro: O arquivo '$INPUT_PDF' não foi encontrado."
    echo "Por favor, verifique se o nome do arquivo está correto e se ele está no diretório atual."
    exit 1
fi

echo "Extraindo marcadores de nível 1 de '$INPUT_PDF'..."

# 1. Extrai todos os dados de marcadores do PDF.
pdftk "$INPUT_PDF" dump_data output - > bookmarks_raw.txt

# 2. Usa 'awk' para filtrar apenas os marcadores de nível 1 e
# formatar os dados de forma que possamos lê-los facilmente.
awk '
    /^BookmarkBegin/ { if (level == 1) print title "|" page; level=0; title=""; page="" }
    /^BookmarkLevel: 1/ { level=1 }
    /^BookmarkTitle:/ { title=$0; sub(/BookmarkTitle: /, "", title); }
    /^BookmarkPageNumber:/ { page=$2 }
    END { if (level == 1) print title "|" page; }
' bookmarks_raw.txt > bookmarks_parsed.txt

# 3. Lê o arquivo processado para criar os arrays de títulos e páginas
mapfile -t chapters < bookmarks_parsed.txt

# 4. Obtém o número total de páginas do livro para o último capítulo
total_paginas=$(pdftk "$INPUT_PDF" dump_data | grep NumberOfPages | awk '{print $2}')
num_capitulos=${#chapters[@]}

# 5. Itera sobre os capítulos para dividir o PDF.
for ((i = 0; i < num_capitulos; i++)); do
    # Formata o contador com zero à esquerda (ex: 01, 02, ..., 10).
    contador=$((i + 1))
    contador_formatado=$(printf "%02d" "$contador")

    # Extrai o título e a página inicial
    titulo=$(echo "${chapters[i]}" | cut -d'|' -f1)
    titulo_limpo=$(echo "$titulo" | sed 's/[^a-zA-Z0-9_ -]/_/g' | sed 's/ /_/g')
    pagina_inicial=$(echo "${chapters[i]}" | cut -d'|' -f2)

    # Determina a página final do capítulo
    if ((i + 1 < num_capitulos)); then
        pagina_final=$(echo "${chapters[i + 1]}" | cut -d'|' -f2 | cut -d' ' -f1)
        pagina_final=$((pagina_final - 1))
    else
        pagina_final=$total_paginas
    fi

    INTERVALO="$pagina_inicial-$pagina_final"
    ARQUIVO_SAIDA="$OUTPUT_DIR/${contador_formatado}_${titulo_limpo}.pdf"

    echo "Dividindo o capítulo '$titulo_limpo' (páginas $INTERVALO) e salvando como '$contador_formatado_${titulo_limpo}.pdf'..."

    pdftk "$INPUT_PDF" cat "$INTERVALO" output "$ARQUIVO_SAIDA"

    if [ $? -eq 0 ]; then
        echo "✓ Capítulo criado com sucesso."
    else
        echo "✗ Erro ao criar o capítulo '$titulo_limpo'."
        ERRO_ENCONTRADO=1
    fi
done

# Limpa os arquivos temporários
rm bookmarks_raw.txt bookmarks_parsed.txt

echo "---"

# 6. Verifica se houve algum erro e, se não, remove o arquivo original.
if [ "$ERRO_ENCONTRADO" -eq 0 ]; then
    echo "Processo concluído! Os capítulos foram criados com sucesso."
    echo "Removendo o arquivo original '$INPUT_PDF'..."
    rm "$INPUT_PDF"
    echo "O arquivo original foi removido."
else
    echo "Processo concluído com erros. O arquivo original '$INPUT_PDF' não será removido."
fi
