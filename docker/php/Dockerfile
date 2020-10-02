FROM php:7.4-fpm-alpine

# Install essential build tools
RUN apk add --no-cache \
    git \
    yarn \
    autoconf \
    g++ \
    fcgi \
    make \
    openssl-dev

# Force UTC as server time
RUN echo "UTC" > /etc/timezone

# Install composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Setup bzip2 extension
RUN apk add --no-cache \
    bzip2-dev \
    && docker-php-ext-install -j$(nproc) bz2 \
    && docker-php-ext-enable bz2 \
    && rm -rf /tmp/*

# Setup GD extension
RUN apk add --no-cache \
      freetype \
      libjpeg-turbo \
      libpng \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && docker-php-ext-configure gd \
      --with-freetype=/usr/include/ \
      # --with-png=/usr/include/ \ # No longer necessary as of 7.4; https://github.com/docker-library/php/pull/910#issuecomment-559383597
      --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && apk del --no-cache \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && rm -rf /tmp/*

# Install intl extension
RUN apk add --no-cache \
    icu-dev \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-enable intl \
    && rm -rf /tmp/*

# Install mbstring extension
RUN apk add --no-cache \
    oniguruma-dev \
    && docker-php-ext-install mbstring \
    && docker-php-ext-enable mbstring \
    && rm -rf /tmp/*

# Install postgresql extension
RUN apk add --no-cache postgresql-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql

# INstall opcache, xdebug, redis
RUN docker-php-source extract \
    && pecl install opcache xdebug redis apcu \
    && docker-php-ext-enable opcache xdebug redis apcu \
    && docker-php-source delete \
    && rm -rf /tmp/*

# INstall opcache, xdebug, redis, mongodb
#RUN docker-php-source extract \
#    && pecl install opcache xdebug redis mongodb apcu \
#    && docker-php-ext-enable opcache xdebug redis mongodb apcu \
#    && docker-php-source delete \
#    && rm -rf /tmp/*

COPY ./xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

WORKDIR /var/www/app
