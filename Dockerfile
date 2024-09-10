FROM php:8.2-fpm

COPY --from=composer /usr/bin/composer /usr/bin/composer
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions zip

USER www-data

WORKDIR /app

COPY --chown=www-data . .

RUN composer install --no-dev --prefer-dist --optimize-autoloader --no-progress --no-interaction \
    && php artisan migrate \
    && php artisan optimize
