# 使用 PHP 8.1 FPM Alpine 3.16
FROM php:8.1-fpm-alpine3.16

# 安装 PHP 扩展、Nginx、Supervisor 及其依赖
RUN apk update && apk add --no-cache \
    freetype \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libwebp-dev \
    libjpeg-turbo-dev \
    autoconf \
    gcc \
    make \
    musl-dev \
    pcre-dev \
    php8-pear \
    php8-dev \
    nginx \
    supervisor \
    # 配置和安装 PHP 扩展
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd \
    && docker-php-ext-install sockets bcmath intl mysqli pdo pdo_mysql zip opcache \
    && pecl install redis \
    && docker-php-ext-enable redis \
    # 清理不再需要的包和缓存
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev autoconf gcc make musl-dev pcre-dev php8-pear php8-dev \
    && rm -rf /var/cache/apk/* \
    # 确保套接字目录存在，并设置权限
    && mkdir -p /var/run/php && chown www-data:www-data /var/run/php


# 复制 Nginx , php-fpm , Supervisor 配置文件
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/laravel_nginx.conf /etc/nginx/conf.d/default.conf
COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 设置工作目录
WORKDIR /var/www/html

# 暴露 8080 端口
EXPOSE 8080

# 设置启动命令，启动php-fpm 和 nginx
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
