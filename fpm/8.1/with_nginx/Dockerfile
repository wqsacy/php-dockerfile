# 阶段 1：PHP 环境
# 基于 PHP 8.1 FPM Alpine 3.16
FROM php:8.1-fpm-alpine3.16 as php-stage

# 安装 PHP 扩展
RUN apk update \
    && apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

# 安装 Redis 扩展依赖项和扩展
RUN apk add --no-cache autoconf gcc make musl-dev pcre-dev php8-pear php8-dev \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del --no-cache autoconf gcc make musl-dev pcre-dev php8-pear php8-dev


# 设置工作目录
WORKDIR /var/www

# 复制 Laravel 项目文件
COPY . /var/www

# 确保 storage 和 bootstrap/cache 目录存在
RUN mkdir -p /var/www/storage /var/www/bootstrap/cache

# 然后设置权限
RUN chown -R www-data:www-data /var/www \
    && find /var/www/storage -type d -exec chmod 755 {} \; \
    && find /var/www/bootstrap/cache -type d -exec chmod 755 {} \;

# 阶段 2：Nginx 环境
# 基于 Nginx Alpine
FROM nginx:alpine as nginx-stage

# 设置工作目录
WORKDIR /var/www

# 复制 Nginx 配置文件
COPY ./config/nginx.conf /etc/nginx/nginx.conf

# 设置 Laravel 的伪静态规则
COPY ./config/laravel_nginx.conf /etc/nginx/conf.d/default.conf

# 暴露 8080 端口
EXPOSE 8080

# 安装 Supervisor
RUN apk add --no-cache supervisor
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 阶段构建，从 PHP 容器复制环境和 Laravel 项目
COPY --from=php-stage /var/www /var/www
COPY --from=php-stage /usr/local/etc/php /usr/local/etc/php
COPY --from=php-stage /usr/local/sbin/php-fpm /usr/local/sbin/php-fpm

# 设置启动命令，启动php-fpm 和 nginx
#CMD ["nginx", "-g", "daemon off;"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]