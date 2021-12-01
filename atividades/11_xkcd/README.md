# XKCD

## Deadline

Prazo: **13/12/2021 (Seg)** pelo link do GitHub (https://classroom.github.com/a/AG7NQ13N).

Você deve escolher seu nome na lista de alunos. Em seguida, o GitHub irá criar um repositório deste trabalho em seu usuário.

## Descrição

O trabalho consiste em desenvolver um script em Bash que baixa pelo menos os últimos 4 comics do site https://xkcd.com/ e organiza as imagens das comics locais. Sempre que uma nova comic é publicada, a mais antiga é descartada.

## Dicas

- Organizar as imagens localmente no formato `NNNN-titulo.png` onde `NNNN` é o número da comic e `titulo` é o título dela. Esse título normalmente é o nome do arquivo.
- Sempre que o script detectar uma nova comic, a mais antiga deve ser descartada.
- Lembre-se de tratar erros de rede.
- XKCD também suporta uma API REST no link https://xkcd.com/json.html
