FROM php:8.1-fpm

# Install Ruby
RUN apt-get update && apt-get install -y -q git rake ruby-ronn zlib1g-dev && apt-get clean

# Install composer
RUN cd /usr/local/bin && curl -sS https://getcomposer.org/installer | php
RUN cd /usr/local/bin && mv composer.phar composer

# Install Nginx
RUN apt-get install -y nginx

# Environment Variable
ENV NGINX_HOST localhost

# Copy Config to Nginx
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default
COPY sites-available/myhost /etc/nginx/laravel.template
COPY sites-available/myhost /etc/nginx/sites-enabled/default
RUN ln /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

# Copy index page for page testing
COPY html/index.php /var/www/html/public/index.php

# Install gettext-base for envsubt
RUN apt-get -y install gettext-base

# Exec Script for Startup
COPY script/run.sh /run.sh
RUN chmod 777 /run.sh
RUN /bin/sh /run.sh

# Run nginx in background
CMD ["nginx", "-g", "daemon off;"]

# Port
EXPOSE 80
EXPOSE 443