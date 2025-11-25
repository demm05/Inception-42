FROM alpine:3.22.0

RUN apk update && \
	apk add --no-cache nginx openssl;

RUN mkdir -p /etc/nginx/ssl;

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=dmelnyk.42.fr/UID=dmelnyk"

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

COPY conf/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
