# Sistemas de Arquivos e Backup


Nesta aula veremos rapidamente o conceito de RAID, o sistema de arquivos Btrfs e como fazer backup incremental na prática.

## RAID

O RAID (*Redundant Array of Independent Disks*) pode ser definido como técnicas de armazenamento para aumentar espaço e segurança tais como divisão, espelhamento e paridade. RAID pode ser feito por hardware (mais eficiente) e software.

Os níveis de RAID mais populares são:
- RAID 0 (*striping*) divide blocos de forma circular entre os discos.
- RAID 1 (*mirroring*) espelha os blocos entre os discos, ou seja, todos são iguais.


## Btrfs

Btrfs é um sistema de arquivos do tipo *copy on write* (CoW) baseado em árvores B que oferece funcionalidades avançadas entre as principais:
- Snapshots 
- RAID em software
- Auto recuperação (*Self-healing*)

Outras funcionalidades podem ser listadas:
- Subvolumes com cotas
- Envio remoto de snapshots
- Compressão
- Integração de volumes lógicos de disco


Mostrar os dados de sistemas de arquivos Btrfs:
```
# btrfs filesystem show
# btrfs filesystem df /mnt/dados
```

Criação do sistema de arquivos com nome `dados`:
```
# mkfs.btrfs -L dados /dev/sdb
# mount -t btrfs /dev/sdb /mnt/dados
```

Podemos usar dois discos para criar um sistema RAID 1 espelhado de metadados e dados.  Note que basta montar um dos discos para o sistema ser montado:
```
# mkfs.btrfs -m raid1 -d raid1 /dev/sdb /dev/sdc
# mount -t btrfs /dev/sdb /mnt/dados
```

Os subvolumes são pastas raízes lógicas separadas que podem ter limites e configurações diferentes como restrições de quotas.
```
# btrfs subvolume create /mnt/dados/novo
# btrfs subvolume list /mnt/dados
```


A criação de snapshots está associada com a funcionalidade de subvolumes. Por exemplo, podemos fazer backup e snapshot da  pasta `HOME` dentro de um subvolume `BACKUP`:
```
# btrfs subvolume create /mnt/dados/HOME
# btrfs subvolume create /mnt/dados/BACKUP
# rsync -av --delete $HOME /mnt/dados/HOME
# btrfs subvolume snapshot /mnt/dados/HOME /mnt/dados/BACKUP/`date +%y-%m-%d_%H-%M`
```

Por fim, também é possível a compressão de arquivos a nível de sistema de arquivo de forma transparente. Ela pode ser habilitada pelas propriedades de um arquivo, opções de montagem, ou desfragmentação.
Novos arquivos irão utilizar a compressão escolhida. Na montagem:
```
mount -t btrfs -o compress=zlib  /dev/sdb /mnt/dados
```
Ou em um arquivo:
```
chattr +c arquivo
btrfs property set arquivo compression zlib
```


## Exemplo de backup

Podemos usar um sistema de backup incremental simples com 2 discos em espelhamento (RAID 1) e usando o script [snapbtrex](https://github.com/yoshtec/snapbtrex). 

A criação do RAID é semelhante aos exemplos anteriores:
```
# mkfs.btrfs -m raid1 -d raid1 /dev/sdb /dev/sdc
# mount -t btrfs /dev/sdb /mnt/dados
# btrfs subvolume create /mnt/dados/HOME
# btrfs subvolume create /mnt/dados/BACKUP
```

Abaixo um script BASH para execução do backup:
```sh
#!/bin/bash

src=/home
dest=/mnt/dados/HOME
snap=/mnt/dados/BACKUP

if [ ! -e $dest ]
then
    echo "File $dest does not exist, quiting."
    exit 0
fi

# copia dos dados excluindo algumas pastas
rsync -av --delete --exclude '.cache/*' --exclude '.local/*' --exclude '.var/*' "$src/"  "$dest/"

# alvo de 200 backups incrementais
$HOME/snapbtrex/snapbtrex.py --snap "$dest/" --path  "$snap/" --target-backups 200 --verbose

exit 0
```

## Links
- https://github.com/yoshtec/snapbtrex
- https://btrfs.wiki.kernel.org/index.php/SnapBtr
- https://btrfs.wiki.kernel.org/