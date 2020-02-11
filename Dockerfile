FROM php:7.3-fpm-alpine

# Install alpine packages and PHP extensions
RUN apk add --update --no-cache acl libzip tzdata supervisor \
  postgresql-libs \
  libpng libjpeg-turbo freetype \
  # Dependencies for phpize (PECL is already installed)
  # https://github.com/docker-library/php/issues/412#issuecomment-297170197
  $PHPIZE_DEPS \
  # Compile PHP extensions: https://hub.docker.com/_/php#php-core-extensions
  # zip: issues/797#issuecomment-486302909
  libzip-dev \
  # pdo_pgsql: issues/221#issuecomment-385775216
  postgresql-dev \
  # gd: issues/225#issuecomment-226870896
  libpng-dev libjpeg-turbo-dev freetype-dev && \
  # Configure and install core extensions with the helper scripts
  docker-php-ext-configure zip --with-libzip=/usr/include && \
  docker-php-ext-configure gd \
    --with-png-dir=/usr/include \
    --with-jpeg-dir=/usr/include \
    --with-freetype-dir=/usr/include && \
  docker-php-ext-install -j$(nproc) bcmath gd zip pdo_mysql pdo_pgsql && \
  # Install and enable PECL extensions
  pecl install redis && \
  docker-php-ext-enable redis && \
  # Alpine development packages cleanup
  apk del --purge $PHPIZE_DEPS \
    libzip-dev \
    postgresql-dev \
    libpng-dev libjpeg-turbo-dev freetype-dev && \
  rm -rf /var/cache/apk/*

# Setup the supervisor configuration
COPY ./supervisor /etc/supervisor

# General configurations
RUN mkdir -p /var/www/html/public \
  /etc/supervisor/conf.d /var/log/supervisor && \
  echo -e "<?php\n\n  phpinfo();\n" > /var/www/html/public/index.php

# Entrypoint scripts (export secrets, wait database, and ACLs for Laravel)
COPY ./entrypoint /entrypoint
ENTRYPOINT ["/entrypoint/main.sh"]

# Supervisor is PID 1, it will take care of starting PHP-FPM and other programs
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
