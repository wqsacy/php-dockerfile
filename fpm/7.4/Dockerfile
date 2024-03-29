FROM php:7.4-fpm-alpine3.15

LABEL maintainer="wqsacy Developers" version="1.0" license="MIT"

ARG COMPOSER_VERSION

ENV COMPOSER_VERSION=${COMPOSER_VERSION:-"2.5.1"}

# trust this project public key to trust the packages.
ADD https://alpine-apk-repository.knowyourself.cc/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub


WORKDIR /opt/www

##
# ---------- building ----------
##
RUN set -ex \
    # change apk source repo
    #&& echo "https://alpine-apk-repository.knowyourself.cc/v3.15/php-7.4" >> /etc/apk/repositories \
    #&& echo "@php https://alpine-apk-repository.knowyourself.cc/v3.15/php-7.4" >> /etc/apk/repositories \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk update \
    && apk add --no-cache --update --virtual .all-deps $PHP_MODULE_DEPS \
    && set -eux \
    && apk add --no-cache --virtual .build-deps \
    ca-certificates \
    curl \
    wget \
    tar \
    xz \
    libressl \
    tzdata \
    pcre \
    php7-cli \
    mysql-client\
    php7-bcmath \
    php7-curl \
    php7-ctype \
    php7-dom \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-mbstring \
    php7-mysqlnd \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-phar \
    php7-posix \
    php7-redis \
    php7-sockets \
    php7-sodium \
    php7-sysvshm \
    php7-sysvmsg \
    php7-sysvsem \
    php7-zip \
    php7-zlib \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-simplexml \
    php7-tokenizer \
    php7-pcntl \
    php7-opcache \
    php7-fileinfo \
    autoconf \
    dpkg-dev \
    dpkg \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    php7-dev \
    php7-pear \
    pkgconf \
    re2c \
    pcre-dev \
    pcre2-dev \
    zlib-dev \
    libtool \
    automake \
    libstdc++ \
    openssl \
    git \
    bash \
    libaio-dev \
    openssl-dev \
    curl-dev \
    freetds-dev \
    freetype-dev \
    gettext-dev \
    libc-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libssh2-dev \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt-dev \
    libzip-dev \
    zlib-dev \
    imagemagick-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/libXpm.* /usr/lib/ \
    && ln -sf /usr/bin/php7 /usr/bin/php \
        && ln -sf /usr/bin/php7 /usr/local/bin/php \
        && ln -sf /usr/bin/phpize7 /usr/local/bin/phpize \
        && ln -sf /usr/bin/php-config7 /usr/local/bin/php-config \
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-webp \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    # install composer
    && wget -nv -O /usr/local/bin/composer https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && chmod u+x /usr/local/bin/composer \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7  /usr/src/*  \
    && php -v \
    && php -m \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"