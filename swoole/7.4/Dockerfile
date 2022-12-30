FROM hyperf/hyperf:7.4-alpine-v3.14-swoole
LABEL maintainer="Hyperf Developers <group@hyperf.io>" version="1.0" license="MIT"



##
# ---------- env settings ----------
##
# --build-arg timezone=Asia/Shanghai
ARG timezone

ENV TIMEZONE=${timezone:-"Asia/Shanghai"} \
    COMPOSER_VERSION=2.1.5 \
    APP_ENV=prod



# update
RUN set -ex \
    && apk update \
    # install composer
    && wget -nv -O /usr/local/bin/composer https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && chmod u+x /usr/local/bin/composer \
    # show php version and extensions
    && php -v \
    && php -m \
    #  ---------- some config ----------
    && cd /etc/php7 \
    # - config PHP
    && { \
        echo "upload_max_filesize=100M"; \
        echo "post_max_size=108M"; \
        echo "memory_limit=1024M"; \
        echo "date.timezone=${TIMEZONE}"; \
    } | tee conf.d/99-overrides.ini \
    # - config timezone
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    # ---------- clear works ----------
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

# mongodb && ssh2
    
RUN set -ex \
    && apk add openssl-dev \
    && apk add php7-mongodb 

RUN set -ex \
    && apk add php7-ssh2 


# 阿里云bug
RUN apk add gnu-libiconv=1.15-r3 --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so


COPY . /opt/www

WORKDIR /opt/www

#RUN composer install --no-dev -o

EXPOSE 9501

COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

ENTRYPOINT echo | /root/start.sh && tail -f /dev/null && exit

#ENTRYPOINT ["php", "/opt/www/bin/hyperf.php", "start”]
