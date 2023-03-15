FROM php:7.4.32-fpm

# Alpine packages
RUN apt-get update && apt-get install -y \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libwebp-dev \
    libxpm-dev \
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
        --with-xpm \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install \
        mysqli \
        bz2 \
        pdo \
        pdo_mysql \
        opcache \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        calendar \
        exif \
        gettext \
        shmop \
        intl \
        bcmath \
    && pecl install \
        swoole-4.8.9 \
        imagick-3.4.3 \
        redis-5.3.7 \
        yaf-3.3.5 \
        igbinary \
        yac-2.3.1

# ycdatabase + swoole_orm
RUN cd /usr/src/php/ext/ \
    && curl -fsSL 'https://jammyfm.oss-cn-qingdao.aliyuncs.com/php-extension/ycdatabase.zip' -o ycdatabase.zip \
    && unzip ycdatabase.zip \
    && rm -rf ycdatabase.zip \
    && cd ycdatabase/ycdatabase_extension \
    && phpize \
    && chmod +x ./configure \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install \
    && cd /usr/src/php/ext/ \
    && curl -fsSL 'https://jammyfm.oss-cn-qingdao.aliyuncs.com/php-extension/ext-orm.zip' -o ext-orm.zip \
    && unzip ext-orm.zip \
    && rm -rf ext-orm.zip \
    && cd ext-orm \
    && phpize \
    && chmod +x ./configure \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install \
    && mv /etc/localtime /etc/localtime.bak \
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "extension=swoole.so" > /usr/local/etc/php/conf.d/swoole.ini \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/phpredis.ini \
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/imagick.ini \
    && echo "extension=igbinary.so" > /usr/local/etc/php/conf.d/igbinary.ini \
    && echo "extension=yac.so" > /usr/local/etc/php/conf.d/z2_yac.ini \
    && echo "extension=yaf.so" > /usr/local/etc/php/conf.d/z2_yaf.ini \
    && echo "extension=swoole_orm.so" > /usr/local/etc/php/conf.d/z3_swoole_orm.ini \
    && echo "extension=ycdatabase.so" > /usr/local/etc/php/conf.d/z1_ycdatabase.ini \
    && mkdir -p /opt/jammyfm/logs/ \
    && chmod -R 777 /opt/jammyfm/logs/

# Copy configuration files
COPY conf/yaf.ini /usr/local/etc/php/conf.d/yaf.ini
COPY conf/php.ini /usr/local/etc/php/php.ini
COPY conf/www.conf /usr
