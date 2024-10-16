FROM php:8.1-fpm

## ====================================================================
## Debian 11 (bullseye)
## ====================================================================

# TOOLS ===============================================================
RUN apt-get -y update
RUN apt-get install -y vim
RUN apt-get install -y nano
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y zip
RUN apt-get install -y unzip
RUN apt-get install -y git
RUN apt-get install -y dos2unix
RUN apt-get install -y graphviz
RUN apt-get install -y iputils-ping
RUN apt-get install -y zstd
RUN apt-get install -y net-tools
RUN apt-get install -y iproute2
RUN apt-get install -y lsof
RUN apt-get install -y net-tools

# PHP Libraries =======================================================
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    g++ \
    libbz2-dev \
    libc6 \
    libc-client-dev \
    libcurl4-gnutls-dev \
    libedit-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libkrb5-dev \
    libldap2-dev \
    libldb-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpq-dev \
    libxml2-dev \
    libonig-dev \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    libxslt1-dev \
    libzip-dev \
    memcached \
    xfonts-base \
    xfonts-75dpi \
    wget \
    unzip \
    zlib1g-dev \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    calendar \
    exif \
    gettext \
    mysqli \
    opcache \
    pdo_mysql \
    soap \
    xsl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && CFLAGS="$CFLAGS -D_GNU_SOURCE" docker-php-ext-install sockets \
    && pecl install memcached && docker-php-ext-enable memcached \
    && yes '' | pecl install imagick && docker-php-ext-enable imagick \
    && docker-php-source delete \
    && apt-get remove -y g++ wget \
    && apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*

# PHP configuration ====================================================
COPY ./config/php.ini /usr/local/etc/php/php.ini
COPY ./config/php.ini-development /usr/local/etc/php/php.ini-development
COPY ./config/php.ini-production /usr/local/etc/php/php.ini-production

# SYMFONY configuration ================================================
RUN mkdir /var/www/my-project-name
COPY ./config/.env.local /var/www/my-project-name

# Xdebug ===============================================================
RUN mkdir /root/tmp
COPY ./config/xdebug-3.2.0.tar.gz /root/tmp/xdebug-3.2.0.tar.gz
COPY ./config/xdebug.ini /root/tmp/xdebug.ini
RUN dos2unix /root/tmp/xdebug-3.2.0.tar.gz

WORKDIR /root/tmp

RUN tar -xvzf xdebug-3.2.0.tar.gz
WORKDIR /root/tmp/xdebug-3.2.0
RUN phpize
RUN ./configure --enable-xdebug
RUN make install

RUN cp /root/tmp/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

### WKhtmltoPDF =============================================================================================

#WORKDIR /root
#
#COPY ./config/wkhtmltox_0.12.6-1.buster_amd64.deb /root/wkhtmltox_0.12.6-1.buster_amd64.deb
#RUN dpkg -i wkhtmltox_0.12.6-1.buster_amd64.deb

### End Build ===============================================================================================

EXPOSE 9000
