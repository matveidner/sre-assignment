#!/bin/bash

while getopts d:e:p: flag
do
	case "${flag}" in
		d) domain=${OPTARG};;
		e) email=${OPTARG};;
		p) path=${OPTARG};;
esac
done


cd ${path}

echo "Generating self-signed certificates."
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:4096 -days 1\
    -keyout '/etc/letsencrypt/live/${domain}/privkey.pem' \
    -out '/etc/letsencrypt/live/${domain}/fullchain.pem' \
    -subj '/CN=localhost'" certbot

echo "Booting up the web server."
docker-compose up --force-recreate -d app

echo "Removing self-signed certificates."
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/${domain} && \
  rm -Rf /etc/letsencrypt/archive/${domain} && \
  rm -Rf /etc/letsencrypt/renewal/${domain}.conf" certbot

"Generating LE certificates."
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot -d ${domain} --email ${email} \
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal" certbot

"Reloading the web server."
docker-compose up --force-recreate -d app