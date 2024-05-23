#!/bin/bash

# Обновление списка пакетов
sudo apt-get update

# Установка Nginx
sudo apt-get install -y nginx

# Запуск Nginx
sudo systemctl start nginx

# Включение Nginx для автозапуска при загрузке системы
sudo systemctl enable nginx

# Создание базовой конфигурации для Nginx
cat <<EOL | sudo tee /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

# Создание символической ссылки в sites-enabled
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Проверка конфигурации Nginx
sudo nginx -t

# Перезапуск Nginx для применения новой конфигурации
sudo systemctl restart nginx

# Установка UFW и настройка брандмауэра
sudo apt-get install -y ufw
sudo ufw allow 'Nginx HTTP'
sudo ufw enable