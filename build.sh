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

echo "Waiting for mysql startup..."
( docker logs -f my-project_mysql 2>&1 & ) | grep -q "MySQL init process done. Ready for start up."
( docker logs -f my-project_mysql 2>&1 & ) | grep -q "mysqld: ready for connections."
echo "Mysql init complete"

docker exec -it -e COMPOSER_MEMORY_LIMIT=-1 my-project_php-fpm composer install --no-interaction --optimize-autoloader --prefer-dist
