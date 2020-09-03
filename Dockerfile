FROM php:7.2-fpm-alpine

MAINTAINER Andrew<ustccq@gmail.com>

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        curl-dev \
        imagemagick-dev \
        libtool \
        libxml2-dev \
        postgresql-dev \
        sqlite-dev \
    && apk add --no-cache \
        nginx \
        curl \
        git \
        imagemagick \
        mysql-client \
	icu-dev \
	openldap-dev \
        postgresql-libs \
	libpng \
	libpng-dev \
	busybox-extras \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install \
        curl \
        iconv \
        mbstring \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        pcntl \
        tokenizer \
        xml \
        zip \
	gd \
	ldap \
	soap \
	exif \
	opcache \
	&& curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer \
	&& apk del -f .build-deps

#RUN composer config -g repo.packagist composer https://packagist.laravel-china.org
#RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# install prestissimo
RUN composer global require "hirak/prestissimo"

# install laravel envoy
RUN composer global require "laravel/envoy"

#install laravel installer
RUN composer global require "laravel/installer"

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update && apk add -u nodejs npm libpng-dev python2

ENV PATH /root/.yarn/bin:$PATH

RUN apk update \
  && apk add curl bash binutils tar \
  && rm -rf /var/cache/apk/* \
  && /bin/sh \
  && touch ~/.bashrc \
  && curl -o- -L https://yarnpkg.com/install.sh | bash \ 
  && mkdir /var/run
#  && yarn config set registry 'https://registry.npm.taobao.org' \
#  && npm set registry=https://registry.npm.taobao.org
#  && npm install --registry=https://registry.npm.taobao.org \
#  && npm run prod

ADD laravel.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www

#COPY entrypoint.sh /var/www/

#RUN chmod 755 /var/www/entrypoint.sh

#ENTRYPOINT ["/var/www/entrypoint.sh"]
