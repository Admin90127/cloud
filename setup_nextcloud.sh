#!/bin/bash

# Обновляем систему
sudo apt update && sudo apt upgrade -y

# Устанавливаем Docker
sudo apt install docker.io -y

# Устанавливаем Docker Compose
sudo apt install docker-compose -y

# Создаем директорию для Nextcloud
mkdir -p ~/nextcloud && cd ~/nextcloud

# Создаем docker-compose.yml файл для Nextcloud
cat <<EOF > docker-compose.yml
version: '3'

services:
  db:
    image: mariadb
    restart: always
    volumes:
      - db:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_PASSWORD: nextcloud
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud

  app:
    image: nextcloud
    ports:
      - 8080:80
    links:
      - db
    volumes:
      - nextcloud:/var/www/html
    restart: always

volumes:
  db:
  nextcloud:
EOF

# Запускаем Docker Compose для развертывания Nextcloud
sudo docker-compose up -d

# Получаем IP-адрес сервера
ip_address=$(hostname -I | awk '{print $1}')
echo "Nextcloud доступен по адресу: http://$ip_address:8080"
