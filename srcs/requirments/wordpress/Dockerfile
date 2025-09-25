FROM debian:12.12-slim

RUN apt update && apt install -y wordpress php-fpm php-mysql php-curl php-json php-xml php-mbstring

COPY ./tools/run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

CMD ["/usr/local/bin/run.sh"]
