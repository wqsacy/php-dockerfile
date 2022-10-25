FROM php:7.4.32-fpm-alpine3.16

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
ENV YAC_VERSION=2.0.3

#Alpine packages
RUN apk add --update git make gcc g++ imagemagick-dev \
	libc-dev \
	autoconf \
	icu-dev \
	openldap-dev \
	freetype-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	libmcrypt-dev \
	libpcre32 \
	libzip \
	bzip2 \
	libbz2 \
	bzip2-dev \
	cyrus-sasl-dev \
	binutils \
	imagemagick-dev \
	&& rm -rf /var/cache/apk/* \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd \
        && docker-php-ext-install mysqli \
        && docker-php-ext-install bz2 \
        && docker-php-ext-install zip \
        && docker-php-ext-install pdo \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache \
		&& docker-php-ext-install sockets \
		&& docker-php-ext-install sysvmsg \
    	&& docker-php-ext-install sysvsem \
    	&& docker-php-ext-install sysvshm \
		&& docker-php-ext-install bcmath


WORKDIR /usr/src/php/ext/

RUN pecl install https://pecl.php.net/get/swoole-4.4.14.tgz \
	&& pecl install https://pecl.php.net/get/imagick-3.4.3.tgz \
	&& pecl install https://pecl.php.net/get/redis-4.2.0.tgz \
	&& pecl install https://pecl.php.net/get/yaf-3.0.9.tgz \
    && set -xe && \
	curl -LO https://github.com/laruence/yac/archive/yac-${YAC_VERSION}.tar.gz && \
	tar xzf yac-${YAC_VERSION}.tar.gz && cd yac-yac-${YAC_VERSION} && \
	phpize && ./configure --with-php-config=/usr/local/bin/php-config && make && make install

COPY docker-entrypoint.sh /usr/local/bin/

ADD conf/yaf.ini /usr/local/etc/php/conf.d/yaf.ini
ADD conf/php.ini /usr/local/etc/php/php.ini
ADD conf/www.conf /usr/local/etc/php-fpm.d/www.conf
ADD conf/docker.conf /usr/local/etc/php-fpm.d/docker.conf
ADD conf/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

#ycdatabase + swoole_orm
RUN cd /tmp/ \
		&& curl -fsSL 'https://jammyfm.oss-cn-qingdao.aliyuncs.com/php-expand/ycdatabase.zip' -o ycdatabase.zip \
		&& unzip ycdatabase.zip \
		&& rm -rf ycdatabase.zip \
		&& cd ycdatabase/ycdatabase_extension \
		&& phpize \
		&& chmod +x ./configure \
		&& ./configure --with-php-config=/usr/local/bin/php-config && make && make install \
		&& cd /tmp && rm -rf ycdatabase \
		&& curl -fsSL 'https://jammyfm.oss-cn-qingdao.aliyuncs.com/php-expand/ext-orm.zip' -o ext-orm.zip \
		&& unzip ext-orm.zip \
		&& rm -rf ext-orm.zip \
		&& cd ext-orm \
		&& phpize \
		&& chmod +x ./configure \
		&& ./configure --with-php-config=/usr/local/bin/php-config && make && make install \
		&& cd /tmp && rm -rf ext-orm \
        && rm /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
		&& chmod +x /usr/local/bin/docker-entrypoint.sh \
		&& echo "extension=swoole.so" > /usr/local/etc/php/conf.d/swoole.ini \
		&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/phpredis.ini \
		&& echo "extension=imagick.so" > /usr/local/etc/php/conf.d/imagick.ini \
		&& echo "extension=swoole_orm.so" > /usr/local/etc/php/conf.d/z_swoole_orm.ini \
		&& echo "extension=ycdatabase.so" > /usr/local/etc/php/conf.d/z_ycdatabase.ini


WORKDIR /opt/jammyfm/www/

EXPOSE 9000

CMD ["/usr/local/bin/docker-entrypoint.sh"]