# Conversor de PDF para Áudio

Este projeto é um conjunto de scripts Bash projetado para automatizar a conversão de um livro em formato PDF para uma série de arquivos de áudio, com cada arquivo de áudio representando um capítulo do livro.

O fluxo de trabalho inclui a divisão do PDF em capítulos individuais (baseado em marcadores), a conversão de cada capítulo para texto, a transformação desse texto em áudio no formato WAV e, finalmente, a conversão do áudio para o formato Opus, que é mais eficiente em termos de compactação.

## Pré-requisitos

Para que os scripts funcionem corretamente, você precisa ter as seguintes dependências instaladas no seu sistema Linux (Ubuntu):

* **`pdftk`**: Utilizado para dividir o PDF em capítulos.
* **`poppler-utils`**: Fornece o comando `pdftotext` para converter PDFs para arquivos de texto.
* **`festival`**: Um sistema de síntese de voz que inclui o comando `text2wave` para converter texto em áudio WAV.
* **`ffmpeg`**: Uma ferramenta poderosa para manipular arquivos de áudio e vídeo, usada aqui para converter arquivos WAV para o formato Opus.

Como Usar
O processo completo é executado através de um único script principal, init.sh, que gerencia a sequência de todas as tarefas. Você deve fornecer o nome do seu arquivo PDF como um parâmetro para este script.

Passo 1: Preparar o Livro
Coloque o seu arquivo PDF na mesma pasta dos scripts.

Certifique-se de que o PDF possui marcadores (bookmarks) de nível 1 para que o script dividir_pdf.sh possa identificar corretamente os capítulos.

Passo 2: Dar Permissão de Execução ao Script
Antes de executar o script init.sh pela primeira vez, você precisa conceder permissão de execução a ele. Abra o terminal na pasta do projeto e use o seguinte comando:

chmod +x init.sh

Passo 3: Executar o Processo de Conversão
Agora você pode executar o script init.sh, passando o nome do seu arquivo PDF como argumento.

./init.sh nome_do_seu_livro.pdf

O script init.sh irá então executar as seguintes tarefas em sequência:

Verificar e instalar as dependências necessárias (se ainda não estiverem instaladas).

Dividir o arquivo PDF em arquivos separados, um para cada capítulo.

Converter cada arquivo PDF de capítulo para texto (.txt).

Converter cada arquivo de texto para áudio no formato WAV (.wav).

Converter o áudio WAV para o formato Opus (.opus) e, em seguida, remover os arquivos WAV para limpar a pasta.

Após a execução bem-sucedida, você terá uma série de arquivos de áudio Opus na mesma pasta, um para cada capítulo do seu livro.

Autor: Lucas de Jesus Soares
Licença: MIT


