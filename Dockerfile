FROM php:8.1-fpm

RUN apt-get update && apt-get install -y -q git rake ruby-ronn zlib1g-dev && apt-get clean
# Install Protoc
RUN cd /usr/local/bin && curl -sS https://getcomposer.org/installer | php
RUN cd /usr/local/bin && mv composer.phar composer
RUN pecl install grpc
# Install Protoc
RUN mkdir -p /tmp/protoc && \
    curl -L https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip > /tmp/protoc/protoc.zip && \
    cd /tmp/protoc && \
    unzip protoc.zip && \
    cp /tmp/protoc/bin/protoc /usr/local/bin && \
    cd /tmp && \
    rm -r /tmp/protoc && \
    docker-php-ext-enable grpc
# Install Nginx
RUN apt-get install -y nginx
RUN php -r "echo extension_loaded('grpc') ? 'yes' : 'no';"
COPY sites-available/myhost /etc/nginx/sites-enabled/myhost
# RUN ln -s /etc/nginx/sites-available/myhost /etc/nginx/sites-enabled/
COPY html/index.php /var/www/html/index.php
# RUN Script for Startup
COPY script/run.sh /run.sh
RUN chmod +x /run.sh
RUN /run.sh
# Port
EXPOSE 80