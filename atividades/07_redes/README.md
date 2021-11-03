# Análise de Rede

## Deadline

Prazo: **17/11/2021 (Qua)** pelo link do GitHub (*a definir*).

Você deve escolher seu nome na lista de alunos. Em seguida, o GitHub irá criar um repositório deste trabalho em seu usuário.

## Descrição

Segurança de redes depende de várias medidas, entre elas análise de
pacotes.  O `tcpdump` é um analisador de pacotes transmitidos sobre uma
rede.

Podemos ler pacotes de rede salvos anteriormente com o comando:
```sh
$ tcpdump -n -r 2021-09-10-traffic-analysis-exercise.pcap
```

A saída será:
```
reading from file 2021-09-10-traffic-analysis-exercise.pcap, link-type EN10MB (Ethernet)
20:15:07.787295 IP 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 00:4f:49:b1:e8:c3, length 302
20:15:07.787997 IP 10.9.10.9.67 > 255.255.255.255.68: BOOTP/DHCP, Reply, length 309
20:15:07.790675 IP 0.0.0.0.68 > 255.255.255.255.67: BOOTP/DHCP, Request from 00:4f:49:b1:e8:c3, length 345
20:15:07.791650 IP 10.9.10.9.67 > 255.255.255.255.68: BOOTP/DHCP, Reply, length 314
20:15:07.932871 IP 169.254.181.227.137 > 169.254.255.255.137: UDP, length 68
20:15:07.932872 IP 169.254.181.227.137 > 169.254.255.255.137: UDP, length 68
20:15:07.932873 IP 169.254.181.227.137 > 169.254.255.255.137: UDP, length 68
20:15:08.684598 IP 169.254.181.227.137 > 169.254.255.255.137: UDP, length 68
20:15:08.684599 IP 169.254.181.227.137 > 169.254.255.255.137: UDP, length 68
20:15:08.684600 IP 169.254.181.227.137 > 169.254.255.255.137: UDP, length 68
20:15:09.495571 IP 169.254.181.227.137 > 169.254.255.255.137: UDP, length 68
20:15:09.531811 IP 10.9.10.102 > 224.0.0.22: igmp v3 report, 1 group record(s)
20:15:09.531812 IP 10.9.10.102 > 224.0.0.22: igmp v3 report, 1 group record(s)
20:15:09.531814 ARP, Request who-has 10.9.10.9 tell 10.9.10.102, length 46
20:15:09.531893 ARP, Reply 10.9.10.9 is-at 14:18:77:0f:c6:9e, length 46
20:15:09.538560 IP 10.9.10.102 > 224.0.0.22: igmp v3 report, 1 group record(s)
20:15:09.538561 IP 10.9.10.102 > 224.0.0.22: igmp v3 report, 1 group record(s)
20:15:09.538659 IP 10.9.10.102.53124 > 10.9.10.9.53: 18599+ A? wpad.angrypoutine.com. (39)
20:15:09.539026 IP 10.9.10.9.53 > 10.9.10.102.53124: 18599 NXDomain* 0/1/0 (118)
20:15:09.547060 IP 10.9.10.102 > 224.0.0.22: igmp v3 report, 1 group record(s)
....
```


Faça uma script para análise desse pacotes fictícios e mostre as
informações abaixo:
1. Hora inicial e hora final da coleta de dados.
2. Quantos IPs internos (LAN) e externos (WAN) de origem foram coletados.
3. Os 5 IPs que mais enviaram pacotes.

Informações sobre a rede fictícia:
- Rede LAN: `10.9.10.0/24` (de `10.9.10.0` a `10.9.10.255`)
- Domínio: `angrypoutine.com`
- LAN gateway: `10.9.10.1`
- Broadcast address: `10.9.10.255`


Arquivo PCAP original: [2021-09-10-traffic-analysis-exercise.pcap](./2021-09-10-traffic-analysis-exercise.pcap.gz)

Saída em formato texto: [2021-09-10-traffic-analysis-exercise.txt](./2021-09-10-traffic-analysis-exercise.txt)

Fonte: https://www.malware-traffic-analysis.net/2021/09/10

## Dicas

- Conte apenas os pacotes IP, descarte pacotes ARP
