FROM debian:12.12-slim

# Dependencies
RUN apt update && apt install -y \
    php \
    php-fpm \
    php-mysql \
    php-curl \
    php-json \
    php-xml \
    php-mbstring \
    php-bcmath \
    php-imagick \
    php-intl \
    php-zip \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./tools/run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

CMD ["/usr/local/bin/run.sh"]
