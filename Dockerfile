FROM php:5.6-apache

RUN a2enmod rewrite

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install \
    curl \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libjpeg-dev \
    libmemcached-dev \
    zlib1g-dev \
    imagemagick

# install the PHP extensions we need
RUN docker-php-ext-install -j$(nproc) iconv mcrypt \
    pdo pdo_mysql mysqli gd
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install exif && \
    docker-php-ext-enable exif

RUN chown -R www-data:www-data /var/www/html

COPY ./conf/docker-php-upload.ini /usr/local/etc/php/conf.d/docker-php-upload.ini
COPY ./conf/db.ini /var/www/html/db.ini
COPY ./conf/.htaccess /var/www/html/.htaccess
COPY ./conf/imagemagick-policy.xml /etc/ImageMagick/policy.xml

CMD ["apache2-foreground"]
