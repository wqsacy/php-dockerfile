# 使用 PHP 8.1 FPM Alpine 3.16
FROM php:8.1-fpm-alpine3.16

# 安装 PHP 扩展、Nginx、Supervisor 及其依赖
RUN apk update && apk add --no-cache \
    freetype \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
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
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && pecl install redis \
    && docker-php-ext-enable redis \
    # 清理不再需要的包和缓存
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev autoconf gcc make musl-dev pcre-dev php8-pear php8-dev \
    && rm -rf /var/cache/apk/*

# 复制 Laravel 项目文件
COPY . /var/www

# 确保 storage 和 bootstrap/cache 目录存在，并设置权限
RUN mkdir -p /var/www/storage /var/www/bootstrap/cache \
    && chown -R www-data:www-data /var/www \
    && find /var/www/storage -type d -exec chmod 755 {} \; \
    && find /var/www/bootstrap/cache -type d -exec chmod 755 {} \;

# 复制 Nginx , php-fpm , Supervisor 配置文件
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/laravel_nginx.conf /etc/nginx/conf.d/default.conf
COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 设置工作目录
WORKDIR /var/www

# 暴露 8080 端口
EXPOSE 8080

# 设置启动命令，启动php-fpm 和 nginx
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]