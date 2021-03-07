#!/bin/bash
UID=`id -u`
GID=`id -g`
cp -n .env.workspace .env
cp -n  src/.env.workspace src/.env
docker-compose down
sudo rm -rf ./.docker/data/mysql
sudo rm -rf ./src/var/cache/*
sudo chown $UID:$GID .

docker-compose up -d nginx php-fpm mysql redis

docker-compose exec php-fpm composer install --no-interaction --optimize-autoloader --prefer-dist
