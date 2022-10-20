#!/bin/bash

domain=$1
email=$2

docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:4096 -days 1\
    -keyout '/etc/letsencrypt/live/${domain}/privkey.pem' \
    -out '/etc/letsencrypt/live/${domain}/fullchain.pem' \
    -subj '/CN=localhost'" certbot

docker-compose up --force-recreate -d app

docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/${domain} && \
  rm -Rf /etc/letsencrypt/archive/${domain} && \
  rm -Rf /etc/letsencrypt/renewal/${domain}.conf" certbot

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot -d ${domain} --email ${email} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot

docker-compose exec app nginx -s reload