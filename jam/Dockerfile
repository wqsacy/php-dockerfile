# 使用 PHP 7.4.33 FPM 作为基础镜像
FROM php:7.4.33-fpm

# 安装 PHP 扩展和必要的库
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
    && docker-php-ext-install -j$(nproc) bcmath intl gd mysqli pdo_mysql opcache fileinfo \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable opcache

# 安装 Redis、Swoole 扩展
RUN pecl install redis swoole-4.8.12 \
    && pecl install yac-2.3.1 \
    && pecl install yaf-3.3.5 \
    && docker-php-ext-enable redis swoole yac yaf

# 安装和配置 swoole_orm 扩展
COPY expansion/swoole_orm /usr/src/swoole_orm
RUN cd /usr/src/swoole_orm && \
    phpize && \
    chmod +x ./configure && \
    ./configure --with-php-config=/usr/local/bin/php-config && \
    make && make install && \
    docker-php-ext-enable swoole_orm

# 安装和配置 ycdatabase 扩展
COPY expansion/ycdatabase /usr/src/ycdatabase
RUN cd /usr/src/ycdatabase/ycdatabase_extension && \
    phpize && \
    chmod +x ./configure && \
    ./configure --with-php-config=/usr/local/bin/php-config && \
    make && make install && \
    docker-php-ext-enable ycdatabase

# 安装 Nginx 和 Supervisor
RUN apt-get install -y nginx supervisor

# 清理并减少镜像大小
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && \
    # 确保套接字目录存在，并设置权限
    && mkdir -p /var/run/php && chown www-data:www-data /var/run/php \
    # 确保环境日志目录存在，并设置权限
    && mkdir -p /var/log && find /var/log -type d -exec chmod 755 {} \;

# 复制配置文件
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY conf/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY conf/yaf.ini /usr/local/etc/php/conf.d/yaf.ini

# 打开 8080 端口
EXPOSE 8080

# 启动 Supervisor 管理 Nginx 和 PHP-FPM
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]