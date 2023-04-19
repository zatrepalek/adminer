# Docker Adminer

This repo contains dockerfile for image with Adminer supporting simultaneous requests (webserver Apache exposed on port 80).

Has in built Adminer SSL extension and suports SSL certificate contents injected via environment variable `DB_SSL_CA_FILE`.

Also it contains [password-less](https://github.com/vrana/adminer/blob/master/plugins/login-password-less.php) plugin to be used with SQL lite (use user and password `test`).

## Usage

Example docker-compose.yml:

```
version: "3.7"

services:
  adminer:
    build: .
    image: zanne/adminer
    ports:
      - 127.0.0.1:8080:80
    volumes:
      - adminer-sessions:/tmp

volumes:
  adminer-sessions: {}
```

This config ensures persistent login and binds Adminer to port 8080 (accessible only from host OS).

## Docker Image

Pull from [Docker Hub registry](https://cloud.docker.com/repository/registry-1.docker.io/zanne/adminer): 

`docker pull zanne/adminer:latest`

## See also

[Adminer](https://www.adminer.org)
