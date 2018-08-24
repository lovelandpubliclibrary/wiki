FROM php:7

MAINTAINER "Kevin Briggs, redisforlosers@gmail.com"

# copy the php configuration to the image
COPY docker/php.ini /usr/local/etc/php/php.ini

# get the node package so we can run 'apt-get install nodejs'
RUN apt-get update -y && apt-get install -y --no-install-recommends gnupg \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -sL https://deb.nodesource.com/setup_6.x | bash

# install dependencies
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y --no-install-recommends \
openssl \
curl \
nodejs \
libmcrypt-dev \
zip \
unzip \
&& docker-php-ext-install pdo_mysql \
&& pecl install mcrypt-1.0.1 \
&& docker-php-ext-enable mcrypt \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /hub

# start the web server
CMD php artisan serve --host=0.0.0.0 --port=10000

# make container accessible on port 10000
EXPOSE 10000