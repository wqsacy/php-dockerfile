# syntax=docker/dockerfile:1
FROM php:8.1-fpm-alpine

# Install necessary PHP extensions and other packages
RUN set -ex; \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        freetype-dev \
        openssl-dev \
        icu-dev \
        imap-dev \
        krb5-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libxpm-dev \
        libzip-dev \
        oniguruma-dev \
    ; \
    \
    docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
        --with-xpm \
    ; \
    \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    \
    docker-php-ext-install -j "$(nproc)" \
        exif \
        sockets \
        fileinfo \
        gd \
        imap \
        intl \
        mysqli \
        pdo_mysql \
        zip \
    ; \
    \
    pecl install redis; \
    docker-php-ext-enable redis; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --no-cache --virtual .phpize-deps-configure $runDeps; \
    apk del .build-deps; \
    \
    docker-php-source delete

# Set recommended PHP.ini settings
RUN { \
        echo 'error_log=/dev/stderr'; \
        echo 'display_errors=Off'; \
        echo 'log_errors=On'; \
        echo 'display_startup_errors=Off'; \
    } > /usr/local/etc/php/conf.d/error-logging.ini

# Set timezone to Shanghai
RUN apk add --no-cache tzdata; \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    echo "Asia/Shanghai" > /etc/timezone; \
    apk del tzdata

# Set recommended FPM settings
RUN set -eux; \
    { \
        echo '[global]'; \
        echo 'error_log = /dev/stderr'; \
        echo; \
        echo '[www]'; \
        echo '; if we send this to /proc/self/fd/1, it never appears'; \
        echo 'access.log = /dev/stderr'; \
        echo; \
        echo 'clear_env = no'; \
        echo; \
        echo 'user = nobody'; \
        echo 'group = nobody'; \
        echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
        echo 'catch_workers_output = yes'; \
    } | tee /usr/local/etc/php-fpm.d/docker.conf

# Add 'll' command as an alias to 'ls -la'
RUN echo "alias ll='ls -la'" >> /etc/profile

# Install git, composer and supervisord
RUN apk add --no-cache git supervisor; \
    \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \
    \
    mkdir -p /var/log/supervisor \
    \
    mkdir -p /etc/supervisord.conf.d; \
    { \
        echo '[unix_http_server]'; \
        echo 'file=/var/run/supervisor.sock'; \
        echo 'chmod=0770'; \
        echo; \
        echo '[supervisord]'; \
        echo 'logfile=/var/log/supervisor/supervisord.log'; \
        echo 'logfile_maxbytes=50MB'; \
        echo 'logfile_backups=10'; \
        echo 'loglevel=info'; \
        echo 'pidfile=/var/run/supervisord.pid'; \
        echo 'nodaemon=true'; \
        echo 'minfds=1024'; \
        echo 'minprocs=200'; \
        echo 'user=root'; \
        echo; \
        echo '[rpcinterface:supervisor]'; \
        echo 'supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface'; \
        echo; \
        echo '[supervisorctl]'; \
        echo 'serverurl=unix:///var/run/supervisor.sock'; \
        echo; \
        echo '[include]'; \
        echo 'files = /etc/supervisord.conf.d/*.conf'; \
        echo; \
        echo '[program:php-fpm]'; \
        echo 'command=php-fpm'; \
        echo 'autostart=true'; \
        echo 'autorestart=true'; \
        echo 'priority=5'; \
        echo 'stdout_logfile=/dev/stdout'; \
        echo 'stdout_logfile_maxbytes=0'; \
        echo 'stderr_logfile=/dev/stderr'; \
        echo 'stderr_logfile_maxbytes=0'; \
    } > /etc/supervisord.conf

# Expose the default FPM port
EXPOSE 9000

# Set the working directory
WORKDIR /opt/www

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
