
# Introdução Docker com Debian/Ubuntu


Esta aula prática tem por objetivo:
- Descrever comandos básicos com containers Docker
- Introduzir conceitos básicos sobre sistemas Linux Debian e/ou Ubuntu.
- Comandos básicos de instalação de pacotes (software) por meio do APT
  (*Advanced Package Tool*).

Nesta descrição, não é descrito como criar redes virtuais e roteadores.


## Docker

Docker é uma plataforma de virtualização a nível de sistema
operacional. O seu uso comum é para rodar software como serviços em pacotes chamados
containers. 

Pode-se instalar Docker em Linux, OSX e Windows, de acordo com o link:
- https://docs.docker.com/engine/install/

### Comandos básicos
Teste sua instalação com o comando:
```
docker info
```

Em seguida, podemos rodar a imagem `hello world`:
```
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://cloud.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/

```

Liste as imagens locais disponíveis:
```
docker images
```

### Criar um container Ubuntu

Para criar um container Ubuntu interativo:
```
docker run -ti ubuntu /bin/bash
```
Onde `-ti` é para ser interativo, `ubuntu` é o nome da imagem e `/bin/bash`
é o nome do comando de entrada do container.

Nós podemos simplesmente rodar um comando em um container:
```
docker run -ti ubuntu 'ls /' 
```

Note que cada execução cria um container **não persistente**, ou seja,
todas as modificações são perdidas. Quando saimos do container, ele é
apenas parado e suas imagem temporária permanece no sistema.

Se digitamos o comando abaixo:
```
$ docker ps -a 
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                       PORTS               NAMES
70a6113a2edb        ubuntu              "/bin/bash"         54 seconds ago      Exited (0) 14 seconds ago                        determined_spence
ff81bb715bed        ubuntu              "ls /"              2 minutes ago       Exited (0) 2 minutes ago                         dazzling_kirch
```
Conseguimos ver nosso dois últimos containers criados e parados. 

Podemos rodar um container chamado *teste* em segundo plano com a opção `-d`:
```
docker run --name teste -tid ubuntu /bin/bash
```

Para ver o container em execução com o comando:
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
7f4258d8609f        ubuntu              "/bin/bash"         5 seconds ago       Up 4 seconds                            teste
```

O comando para conectar novamente com o container é:
```
docker attach teste
```

Quando sair, o container será parado e a imagem temporária
permanece. Para criar um container sem deixar uma imagem temporária
use a opção `--rm`:
```
docker run --rm -ti ubuntu /bin/bash
```

### Limpar imagens

Para apagar imagens, containers e volumes não associados a um
container:
```
docker system prune
```

Ou para apagar todas as imagens sem uso, ou seja, nenhum container
está utilizando no momento:
```
docker system prune -a
```
### Volumes

Arquivos criados dentro de um container não são persistentes. Para tanto, Docker tem duas opções de armazenamento persistente mesmo depois do fim de um container: *volumes* e *bind mounts*.

Os **volumes** são os mais indicados e gerenciados pelo Docker sendo armazenados no sistema de arquivos interno. O primeiro passo é criar o volume:
```
docker volume create meu-volume
```
Em seguida podemos mapear o volume dentro do container na pasta `/dados`:
```
docker run --rm -ti -v meu-volume:/dados ubuntu /bin/bash
```
O volume persiste mesmo com o fim do container. A remoção deve ser explícita com:
```
docker volume rm meu-volume
```

Os **bind mounts** são diretórios mapeados dentro do container. O caminho do diretório precisa ser absoluto sempre como no exemplo abaixo da pasta `dados`:
```
docker run --rm -ti -v $(pwd)/dados:/dados ubuntu /bin/bash
```

## Pacotes com APT

Todos os exemplos a partir desta parte usam um container Ubuntu.

### Atualizar lista de pacotes

Sempre que instalar ou atualizar pacotes, faça uma atualização do
banco de dados de pacotes:
```
$ apt update
```
A lista de repositórios fica no arquivo `/etc/apt/sources.list`. Veja os
links para uma lista completa de espelhos [Debian](https://www.debian.org/mirror/list) e [Ubuntu](https://launchpad.net/ubuntu/+archivemirrors).

### Procurar pacotes

Se deseja procurar os pacotes disponíveis sobre atari:
```
$ apt search atari
Sorting... Done
Full Text Search... Done
aranym/bionic 1.0.2-2.2 amd64
  Atari Running on Any Machine

atari800/bionic 3.1.0-2build2 amd64
  Atari 8-bit emulator for SDL

fonts-atarismall/bionic 2.2-4 all
  Very small 4 x 8 font

gnurobbo/bionic 0.68+dfsg-3 amd64
  logic game ported from ATARI XE/XL

gnurobbo-data/bionic 0.68+dfsg-3 all
  logic game ported from ATARI XE/XL - data files

hatari/bionic 2.1.0+dfsg-1 amd64
  Emulator for the Atari ST, STE, TT, and Falcon computers

stella/bionic 5.1.1-1 amd64
  Atari 2600 Emulator for SDL & the X Window System

virtualjaguar/bionic 2.1.3-2 amd64
  Cross-platform Atari Jaguar emulator
```

Para obter mais detalhes sobre um pacote específico:
```
$ apt show stella
Package: stella
Version: 5.1.1-1
Priority: optional
Section: universe/otherosfs
Origin: Ubuntu
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Original-Maintainer: Debian Games Team <pkg-games-devel@lists.alioth.debian.org>
Bugs: https://bugs.launchpad.net/ubuntu/+filebug
Installed-Size: 6746 kB
Depends: libc6 (>= 2.14), libgcc1 (>= 1:3.0), libpng16-16 (>= 1.6.2-1), libsdl2-2.0-0 (>= 2.0.7), libstdc++6 (>= 6), zlib1g (>= 1:1.1.4)
Recommends: joystick (>= 1:1.5.1)
Homepage: https://stella-emu.github.io
Download-Size: 1534 kB
APT-Sources: http://archive.ubuntu.com/ubuntu bionic/universe amd64 Packages
Description: Atari 2600 Emulator for SDL & the X Window System
```

### Instalação

A instalação de um pacote é com:
```
apt install htop
```

Caso tenha danificado a instalação do pacote, removendo arquivos por
exemplo, basta reinstalar com:
```
apt install --reinstall htop
```

### Remover pacotes
E para remover um ou mais pacotes:
```
apt remove htop
```

O comando acima remove os pacotes, mas os arquivos de configuração
permanecerão intactos. Uma remoção completa (incluindo arquivos de
configuração) use:
```
apt purge apache2
```

Se alguns pacotes sobraram no sistema, devido a dependências, basta
remover com:
```
apt autoremove
```

### Atualização do sistema
O APT também permite atualizar os pacotes da distribuição (ou versão)
com o comando:
```
apt upgrade
```

A atualização completa da distribuição depende de especificar o
*codename* (jessie, stretch, etc) e status dela (oldstable, stable,
testing, unstable) no arquivo `/etc/apt/sources.list`. Depois, basta
fazer a atualização:
```
apt full-upgrade
```


## Informações de pacotes com DPKG

O `dpkg` é uma ferramenta que instala, compila, remove e gerencia
pacotes Debian. Se deseja, por exemplo, obter a lista de pacotes
instalados no sistema:
```
dpkg -l
```

Ou procurar o pacote que um arquivo pertence:
```
$ dpkg -S tiny
vim-tiny: /usr/share/lintian/overrides/vim-tiny
vim-tiny: /usr/share/vim/vimrc.tiny
vim-tiny: /usr/share/doc/vim-tiny/NEWS.Debian.gz
vim-tiny: /usr/bin/vim.tiny
vim-tiny: /usr/share/bug/vim-tiny/script
vim-tiny: /etc/vim/vimrc.tiny
vim-tiny: /usr/share/bug/vim-tiny
vim-tiny: /usr/share/bug/vim-tiny/presubj
vim-tiny: /usr/share/doc/vim-tiny/changelog.Debian.gz
vim-tiny: /usr/share/doc/vim-tiny/copyright
vim-tiny: /usr/share/doc/vim-tiny
```

# Referências
- https://www.debian.org/doc/manuals/apt-howto/index.pt-br.html
- https://help.ubuntu.com/lts/serverguide/apt.html
- https://docs.docker.com/get-started/
