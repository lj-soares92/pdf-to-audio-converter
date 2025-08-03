#!/bin/bash

# --- Verifica e Instala as Dependências ---
# Este script irá verificar se os pacotes necessários estão instalados e
# os instalará caso não estejam.

# Função para verificar e instalar um pacote
check_and_install() {
    PACKAGE_NAME=$1
    if ! dpkg -s "$PACKAGE_NAME" >/dev/null 2>&1; then
        echo "O pacote '$PACKAGE_NAME' não está instalado. Instalando agora..."
        sudo apt-get update
        sudo apt-get install -y "$PACKAGE_NAME"
    else
        echo "O pacote '$PACKAGE_NAME' já está instalado."
    fi
}

echo "--- Iniciando a configuração das dependências ---"

# Necessário para 'dividir_pdf.sh'
# Este script usa 'pdftk' para dividir um PDF em capítulos com base em marcadores.
# Observação: 'pdftk' não está disponível nos repositórios padrão do Ubuntu em algumas versões mais recentes.
# Pode ser necessário um PPA para instalá-lo.
check_and_install pdftk

# Necessário para 'convert_pdfs.sh'
# Este script usa 'pdftotext' para converter arquivos PDF para TXT.
# O comando 'pdftotext' faz parte do pacote 'poppler-utils'.
check_and_install poppler-utils

# Necessário para 'converter.sh'
# Este script usa 'text2wave' para converter arquivos de texto para áudio WAV.
# O comando 'text2wave' faz parte do sistema de síntese de voz 'festival'.
check_and_install festival

# Necessário para 'wave2opus.sh'
# Este script usa 'ffmpeg' para converter arquivos de áudio WAV para o formato Opus.
check_and_install ffmpeg

echo "--- Configuração de dependências finalizada ---"
