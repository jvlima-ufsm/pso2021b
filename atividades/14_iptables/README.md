# Análise de Log IPTables

## Deadline

Prazo: **22/12/2021 (Seg)** pelo link do GitHub (https://classroom.github.com/a/9duKWACQ).

Você deve escolher seu nome na lista de alunos. Em seguida, o GitHub irá criar um repositório deste trabalho em seu usuário.

## Descrição

O trabalho consiste em desenvolver um analisador de log IPTables do
Linux. O [IPTables](http://www.netfilter.org/) é a ferramenta para criação de regras de firewall em
distribuições Linux modernas. Essas regras geram logs de sistema no
formato abaixo:
```
Feb  1 00:00:02 bridge kernel: INBOUND TCP: IN=br0 PHYSIN=eth0 OUT=br0 PHYSOUT=eth1 SRC=192.150.249.87 DST=11.11.11.84 LEN=40 TOS=0x00 PREC=0x00 TTL=110 ID=12973 PROTO=TCP SPT=220 DPT=6129 WINDOW=16384 RES=0x00 SYN URGP=0
```
Variações desse formato são possíveis; todavia, os campos não mudam.

## Requisitos
O analisador deve ser desenvolvido em script Bash e mostrar os dados
em ordem:
1. Número total de pacotes
2. Top 10 IPs fonte e quantos pacotes cada um
3. Top 10 IPs destino e quantos pacotes cada um
4. Contagem de pacotes por protocolo (TCP, UDP, ICMP)

O formato de saída é livre, e de preferência compacto e
simples. Procure criar uma função Bash para cada tarefa apresentada
acima.

A execução do script deve receber como parâmetro o arquivo log analisado:
```
$ ./analisa.sh SotM30-anton.log
```

Abaixo uma lista de sites com logs IPTables disponíveis:
- http://log-sharing.dreamhosters.com/

## Regras
- O trabalho é individual.
