# 使用 PHP 7.4.33 FPM 作为基础镜像
FROM php:7.4.33-fpm-buster

# 复制 swoole_orm 和 ycdatabase 源码
COPY expansion/swoole_orm /usr/src/swoole_orm
COPY expansion/ycdatabase /usr/src/ycdatabase

# 安装 PHP 扩展、必要的库、配置 swoole_orm 和 ycdatabase 扩展，并清理
RUN apt-get update && apt-get install -y --no-install-recommends \
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
        nginx \
        supervisor \
    && docker-php-ext-install -j$(nproc) bcmath intl gd mysqli pdo_mysql opcache fileinfo \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable opcache \
    && pecl install -D 'enable-sockets="no" enable-openssl="yes" enable-http2="yes" enable-mysqlnd="yes" enable-swoole-json="no" enable-swoole-curl="yes" enable-cares="yes"' swoole \
    && pecl install redis yac-2.3.1 yaf-3.3.5 \
    && docker-php-ext-enable redis swoole yac yaf \
    && cd /usr/src/swoole_orm && \
        phpize && \
        chmod +x ./configure && \
        ./configure --with-php-config=/usr/local/bin/php-config && \
        make && make install && \
        docker-php-ext-enable swoole_orm \
    && cd /usr/src/ycdatabase/ycdatabase_extension && \
        phpize && \
        chmod +x ./configure && \
        ./configure --with-php-config=/usr/local/bin/php-config && \
        make && make install && \
        docker-php-ext-enable ycdatabase \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /usr/src/swoole_orm /usr/src/ycdatabase \
    && mkdir -p /var/run/php && chown www-data:www-data /var/run/php \
    && mkdir -p /var/log && find /var/log -type d -exec chmod 755 {} \;

# 复制配置文件
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY conf/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY conf/yaf.ini /usr/local/etc/php/conf.d/yaf.ini

# 设置工作目录
WORKDIR /opt/jammyfm/www/

# 打开 8080 端口
EXPOSE 8080

# 启动 Supervisor 管理 Nginx 和 PHP-FPM
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]