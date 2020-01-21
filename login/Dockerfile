FROM php:7-fpm-alpine
RUN docker-php-ext-install mysqli
WORKDIR /www
ADD ./www .
RUN sed -i -e 's/localhost/db/g' config.php