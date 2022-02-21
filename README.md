# nginxsecureproxy
Docker Container from NGiNX Image with integrated SSL Encrytpion. Simple to use for Proxy or normal Web Server.

If you want to implement a feature, do a FR, Issue or PR. 

# docker-compose.yml

```version: '3.4'

services:
  nginx:
    image: pthoelken/nginxsecureproxy
    container_name: nginxsecureproxy
    restart: always
    volumes:
      - ./nginxssl/nginx/conf.d:/etc/nginx/conf.d
      - ./nginxssl/nginx/www:/var/www
      - ./nginxssl/cert/certwebdata:/var/www/certbot
      - ./nginxssl/cert/certificates:/etc/letsencrypt/live
      - ./nginxssl/cert/log:/var/log/letsencrypt
      - ./nginxssl/cert/certifylog:/etc/certify/log
    ports:
      - "80:80"
      - "443:443"
```

# Usage
Import new Domain and create certificate
- `docker exec nginxsecureproxy certify --newcert yourdomain.com mail@yourmail.com`

Reload NGiNX Configurations
- `docker exec nginxsecureproxy certify --reload`

Edit your NGiNX configuration files
- ./nginxssl/nginx/conf.d/*
- Just add your own files. Do not edit system files.

# Explaination

| Local Folder      | Container Mapping | Description |
| ----------- | ----------- | ----------- |
| ./nginxssl/nginx/conf.d      | /etc/nginx/conf.d       | Configuration Folder for NGiNX Server      |
| ./nginxssl/nginx/www   | /var/www        | www Folder for Domains        |
| ./nginxssl/cert/certwebdata   | /var/www/certbot        | Data folder for Certificates. Do not Edit files here        |
| ./nginxssl/cert/certificates   | /etc/letsencrypt/live        | Certificate Storage. Do not Edit files here        |
| ./nginxssl/cert/log   | /var/log/letsencrypt        | Log Folder for LetsEncrypt        |
| ./nginxssl/cert/certifylog   | /etc/certify/log        | Log Folder for Certify        |
| ./nginxssl/nginx/php | /etc/php/8.0 | Config folder for php |

# Docker Hub Location
- https://hub.docker.com/repository/docker/pthoelken/nginxsecureproxy