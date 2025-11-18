FROM alpine:3.22.0

RUN apk update && \
	apk add --no-cache nginx;

RUN mkdir -p /etc/nginx/ssl;

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=dmelnyk.42.fr/UID=dmelnyk"

RUN chmod 755 /var/www/html;
RUN chown -R nginx:nginx /var/www/html

COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
