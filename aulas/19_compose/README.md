# Docker Compose

Compose é uma ferramenta para definição de uma aplicação composta de múltiplos containers por meio de um arquivo YAML de configuração chamado `docker-compose.yml`. Os serviços descritos no arquivo também são chamados de micro-serviços.


## Instalação

O compose é um arquivo script que basta ser instalado localmente com os comandos abaixo:
```
$ sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

## Primeiros passos

O primeiro exemplo é rodar o servidor web [nginx](https://nginx.org/en/) como um serviço usando compose:
```
services:
  web:
    image: nginx
    ports:
      - "8080:80"
    environment:
      - NGINX_HOST=foo.com
      - NGINX_PORT=80
```
Definimos o serviço com nome `web` descrito pela imagem `nginx`, mapeado na porta `8080`. Para rodar o serviço:
```
$ docker-compose up -d
```
A página padrão do nginx pode ser acessada em http://localhost:8080 sendo vazia. O serviço pode ser parado com o comando:
```
$ docker-compose down
```

## Mapeamento de arquivos

Podemos especificar o mapeamento de arquivos no serviço criado com o formato:
```
services:
  web:
    image: nginx
    ports:
      - "8080:80"
    volumes:
      - ./:/usr/share/nginx/html
    environment:
      - NGINX_HOST=foo.com
      - NGINX_PORT=80
```

Também podemos usar volumes persistentes para armazenamento como abaixo:
```
services:
  web:
    image: nginx
    ports:
      - "8080:80"
    volumes:
      - www_data:/usr/share/nginx/html
    environment:
      - NGINX_HOST=foo.com
      - NGINX_PORT=80

volumes:
    www_data: 
```

## Rede

Quando especificamos mais de um serviço em um arquivo compose, ele cria uma rede interna onde o nome do serviço é usado como nome DNS do serviço.  No exemplo abaixo, temos o serviço `wordpress` junto com o serviço de banco de dados `db`:
```
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "8080:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress

volumes:
  db_data:
  wordpress_data:
```
Note que apenas o serviço `wordpress` tem uma porta mapeada sendo o `db` um serviço isolado e dedicado apenas ao Wordpress. Também os serviços possuem a configuração `restart: always` que permite  a execução persistente, ou seja, esse serviço será executado novamente caso o host seja reiniciado ou apresentar alguma falha de execução.

## Links
- https://docs.docker.com/compose/
- https://docs.docker.com/samples/wordpress/
- https://docs.docker.com/compose/install/
- https://hub.docker.com/_/nginx/
