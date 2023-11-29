# 基于官方PHP 7.4
FROM php:7.4.33-fpm

# 安装必要的软件包和PHP扩展
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxpm-dev \
    libwebp-dev \
    libzip-dev \
    libonig-dev \
    libmagickwand-dev \
    libssl-dev \
    wget \
    unzip \
    git \
    && docker-php-ext-configure gd \
               --enable-gd \
               --with-freetype \
               --with-jpeg \
               --with-webp \
               --with-xpm \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql opcache fileinfo

# 安装Swoole, Yaf, Yac, igbinary
RUN pecl install swoole-4.8.9 \
    && pecl install redis \
    && pecl install imagick \
    && pecl install igbinary-3.2.6 \
    && pecl install yac-2.3.1 \
    && pecl install yaf-3.3.5 \
    && docker-php-ext-enable swoole redis imagick igbinary yac yaf

# 下载并编译ycdatabase和ext-orm
RUN cd /tmp/ \
    && wget https://jammyfm.oss-cn-qingdao.aliyuncs.com/php-extension/ycdatabase.zip \
    && unzip ycdatabase.zip \
    && cd ycdatabase/ycdatabase_extension \
    && phpize \
    && chmod +x ./configure \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install \
    && cd /tmp/ \
    && rm -rf ycdatabase ycdatabase.zip

RUN cd /tmp/ \
    && wget https://jammyfm.oss-cn-qingdao.aliyuncs.com/php-extension/ext-orm.zip \
    && unzip ext-orm.zip \
    && cd ext-orm \
    && phpize \
    && chmod +x ./configure \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install \
    && cd /tmp/ \
    && rm -rf ext-orm ext-orm.zip

# 配置加载顺序
RUN echo "extension=swoole.so" > $PHP_INI_DIR/conf.d/10-swoole.ini \
    && echo "extension=redis.so" > $PHP_INI_DIR/conf.d/20-redis.ini \
    && echo "extension=imagick.so" > $PHP_INI_DIR/conf.d/30-imagick.ini \
    && echo "extension=igbinary.so" > $PHP_INI_DIR/conf.d/40-igbinary.ini \
    && echo "extension=yac.so" > $PHP_INI_DIR/conf.d/50-yac.ini \
    && echo "extension=yaf.so" > $PHP_INI_DIR/conf.d/60-yaf.ini \
    && echo "extension=swoole_orm.so" > $PHP_INI_DIR/conf.d/70-swoole_orm.ini \
    && echo "extension=ycdatabase.so" > $PHP_INI_DIR/conf.d/80-ycdatabase.ini

# 设置工作目录
WORKDIR /opt/jammyfm/www