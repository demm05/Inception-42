FROM alpine:3.19

# Install PHP and necessary extensions
# Note: PHP versions in Alpine repositories change. verify version (e.g., php81, php82, or just php)
RUN apk update && apk upgrade && apk add --no-cache \
    php \
    php-fpm \
    php-mysqli \
    php-json \
    php-curl \
    php-dom \
    php-exif \
    php-fileinfo \
    php-mbstring \
    php-openssl \
    php-xml \
    php-zip \
    wget \
    unzip

RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf

COPY tools/run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/run.sh"]
