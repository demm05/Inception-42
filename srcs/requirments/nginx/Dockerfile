FROM alpine:3.22.0

RUN apk update && \
	apk add --no-cache nginx

RUN adduser -D -g 'www' www

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./www /www

COPY ./tools/run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 443

CMD ["/usr/local/bin/run.sh"]
