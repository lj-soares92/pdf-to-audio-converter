#!/bin/bash

# --- Script de Inicialização para o Conversor de PDF para Áudio ---
# Este script executa a sequência completa de scripts para converter um PDF
# em uma série de arquivos de áudio Opus, um para cada capítulo.

# Checa se o nome do arquivo foi fornecido como parâmetro
if [ -z "$1" ]; then
    echo "Erro: Por favor, forneça o nome do arquivo PDF como argumento."
    echo "Uso: ./init.sh <nome_do_arquivo.pdf>"
    exit 1
fi

INPUT_PDF="$1"

# 1. Configurar o ambiente (instalar dependências)
echo "Passo 1/5: Configurando o ambiente e instalando as dependências..."
./config.sh
if [ $? -ne 0 ]; then
    echo "Erro na configuração. Verifique se o 'config.sh' foi executado corretamente."
    exit 1
fi

# 2. Dividir o PDF em capítulos individuais
echo "Passo 2/5: Dividindo o PDF em capítulos..."
# O script 'dividir_pdf.sh' agora é chamado com o nome do arquivo como parâmetro
./split_pdf.sh "$INPUT_PDF"
if [ $? -ne 0 ]; then
    echo "Erro ao dividir o PDF. Verifique o arquivo de entrada e o script 'dividir_pdf.sh'."
    exit 1
fi

# 3. Converter os PDFs dos capítulos para texto
echo "Passo 3/5: Convertendo PDFs para texto..."
./convert_pdfs.sh
if [ $? -ne 0 ]; then
    echo "Erro ao converter PDFs para texto. Verifique o script 'convert_pdfs.sh'."
    exit 1
fi

# 4. Converter os arquivos de texto para áudio WAV
echo "Passo 4/5: Convertendo texto para áudio WAV..."
./converter.sh
if [ $? -ne 0 ]; then
    echo "Erro ao converter texto para áudio WAV. Verifique o script 'converter.sh'."
    exit 1
fi

# 5. Converter áudio WAV para Opus e remover os arquivos temporários
echo "Passo 5/5: Convertendo WAV para Opus e limpando arquivos temporários..."
./wave2opus.sh
if [ $? -ne 0 ]; then
    echo "Erro ao converter WAV para Opus. Verifique o script 'wave2opus.sh'."
    exit 1
fi

echo "--- Processo de conversão concluído com sucesso! ---"
echo "Os arquivos de áudio Opus estão prontos na pasta atual."
