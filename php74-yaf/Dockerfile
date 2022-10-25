FROM php:7.4-fpm-alpine

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

#Alpine packages
RUN apk add --update  libffi-dev openssl-dev libtool util-linux git make gcc g++ imagemagick-dev \
	libc-dev \
	autoconf \
	icu-dev \
	openldap-dev \
	freetype-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	libmcrypt-dev \
	libpcre32 \
	libzip-dev \
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

RUN pecl install https://pecl.php.net/get/swoole-4.8.9.tgz \
	&& pecl install https://pecl.php.net/get/imagick-3.4.3.tgz \
	&& pecl install https://pecl.php.net/get/redis-5.3.7.tgz \
	&& pecl install https://pecl.php.net/get/yaf-3.3.5.tgz \
	&& pecl install igbinary \
    && pecl install https://pecl.php.net/get/yac-2.3.1.tgz

COPY docker-entrypoint.sh /usr/local/bin/

ADD conf/yaf.ini /usr/local/etc/php/conf.d/yaf.ini
ADD conf/php.ini /usr/local/etc/php/php.ini
ADD conf/www.conf /usr/local/etc/php-fpm.d/www.conf
ADD conf/docker.conf /usr/local/etc/php-fpm.d/docker.conf
ADD conf/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

#ycdatabase + swoole_orm
RUN cd /usr/src/php/ext/ \
		&& curl -fsSL 'https://jammyfm.oss-cn-qingdao.aliyuncs.com/php-extension/ycdatabase.zip' -o ycdatabase.zip \
		&& unzip ycdatabase.zip \
		&& rm -rf ycdatabase.zip \
		&& cd ycdatabase/ycdatabase_extension \
		&& phpize \
		&& chmod +x ./configure \
		&& ./configure --with-php-config=/usr/local/bin/php-config && make && make install \
		&& cd /usr/src/php/ext/ \
		&& curl -fsSL 'https://jammyfm.oss-cn-qingdao.aliyuncs.com/php-extension/ext-orm.zip' -o ext-orm.zip \
		&& unzip ext-orm.zip \
		&& rm -rf ext-orm.zip \
		&& cd ext-orm \
		&& phpize \
		&& chmod +x ./configure \
		&& ./configure --with-php-config=/usr/local/bin/php-config && make && make install \
        && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
		&& chmod +x /usr/local/bin/docker-entrypoint.sh \
		&& echo "extension=swoole.so" > /usr/local/etc/php/conf.d/swoole.ini \
		&& echo "extension=redis.so" > /usr/local/etc/php/conf.d/phpredis.ini \
		&& echo "extension=imagick.so" > /usr/local/etc/php/conf.d/imagick.ini \
		&& echo "extension=igbinary.so" > /usr/local/etc/php/conf.d/igbinary.ini \
		&& echo "extension=yac.so" > /usr/local/etc/php/conf.d/z2_yac.ini \
		&& echo "extension=yaf.so" > /usr/local/etc/php/conf.d/z2_yaf.ini \
		&& echo "extension=swoole_orm.so" > /usr/local/etc/php/conf.d/z3_swoole_orm.ini \
		&& echo "extension=ycdatabase.so" > /usr/local/etc/php/conf.d/z1_ycdatabase.ini \
        && mkdir -p /opt/jammyfm/logs/ \
        && chmod -R 777 /opt/jammyfm/logs/


WORKDIR /opt/jammyfm/www/

EXPOSE 9000

CMD ["/usr/local/bin/docker-entrypoint.sh","run"]