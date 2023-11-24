# 阶段 1：PHP 环境
# 基于 PHP 8.1 FPM Alpine 3.16
FROM php:8.1-fpm-alpine3.16 as php-stage

# 安装 PHP 扩展
RUN docker-php-ext-install pdo pdo_mysql fileinfo
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

# 安装 Redis 扩展
RUN apk add --no-cache redis
RUN pecl install redis && docker-php-ext-enable redis

# 设置工作目录
WORKDIR /var/www

# 复制 Laravel 项目文件
COPY . /var/www

# 设置权限
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage \
    && chmod -R 755 /var/www/bootstrap/cache

# 安装 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# 清理缓存
RUN composer clear-cache

# 阶段 2：Nginx 环境
# 基于 Nginx Alpine
FROM nginx:alpine as nginx-stage

# 设置工作目录
WORKDIR /var/www

# 复制 Nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 设置 Laravel 的伪静态规则
COPY fpm/8.1/with_nginx/laravel_nginx.conf /etc/nginx/conf.d/default.conf

# 暴露 8080 端口
EXPOSE 8080

# 安装 Supervisor
RUN apk add --no-cache supervisor
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 阶段构建，从 PHP 容器复制已经安装好的 Laravel 项目
COPY --from=php-stage /var/www /var/www

# 设置启动命令
CMD ["nginx", "-g", "daemon off;"]