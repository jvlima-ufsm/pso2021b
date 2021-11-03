# Ordenação em Bash

## Deadline

Prazo: **10/11/2021 (Qua)** pelo link do GitHub (https://classroom.github.com/a/xbh37Ie6).

Você deve escolher seu nome na lista de alunos. Em seguida, o GitHub irá criar um repositório deste trabalho em seu usuário.

## Descrição

Ordene usuários de acordo com o formato de entrada abaixo em cada
tarefa:
1. Ordem por login (ordem alfabética)
2. Ordem por nome
3. Agregados por grupo, e ordenados por nome (ordem reversa)
4. Ordenar por idade (ordem numérica)

Formato de entrada:
``` 
login|name|group|age
```

Exemplo de entrada: [a6-input-example.txt](./a6-input-example.txt). Para gerar novas
entradas, use o script [gen-random-users.sh](./gen-random-users.sh).

Cada agrupamento começa com 2 espaços antes de cada linha. A saída esperada será:
```
Task 1:
  Ana Mendes Alves
  Antonio Alves Barbosa
  Francisco Rezende Campos
  Francisco Barbosa Lima
  Francisco Barros Rodrigues
  Gabriel Freitas Gomes
  Jose Moura Pereira
  Luiz Novaes Martins
  Maria Barbosa Monteiro
  Paulo Cavalcanti Ribeiro
Task 2:
  Ana Mendes Alves
  Antonio Alves Barbosa
  Francisco Barbosa Lima
  Francisco Barros Rodrigues
  Francisco Rezende Campos
  Gabriel Freitas Gomes
  Jose Moura Pereira
  Luiz Novaes Martins
  Maria Barbosa Monteiro
  Paulo Cavalcanti Ribeiro
Task 3:
  inf2001:
    Francisco Rezende Campos
  inf2002:
    Jose Moura Pereira
    Francisco Barros Rodrigues
  inf2003:
    Paulo Cavalcanti Ribeiro
  inf2004:
    Maria Barbosa Monteiro
    Antonio Alves Barbosa
  inf2005:
    Francisco Barbosa Lima
  inf2006:
    Luiz Novaes Martins
    Gabriel Freitas Gomes
    Ana Mendes Alves
Task 4:
  Antonio Alves Barbosa
  Paulo Cavalcanti Ribeiro
  Francisco Barbosa Lima
  Jose Moura Pereira
  Luiz Novaes Martins
  Ana Mendes Alves
  Francisco Rezende Campos
  Maria Barbosa Monteiro
  Francisco Barros Rodrigues
  Gabriel Freitas Gomes
```

Uma execução de teste deve ser feita de acordo com o comando abaixo:
```sh
$ ./t1.sh a6-input-example.txt
```

**Comandos básicos** - `cat`, `sort`, `uniq`, `cut`.

Dicas:
- Organize cada tarefa em funções Bash
- Nomeie o nome do arquivo como `t1.sh`
- Procure informações sobre as opções em cada comando

Uma função em `bash` tem o seguinte formato:
```sh
#!/bin/bash

tarefa1(){
    echo "Task 1:"
    cat $1 |  sort -t'|' -k 1|cut -d '|' -f2 | sed 's/\(.*\)/  \1/g'
}

tarefa1 $1
```
