FROM alpine:3.22.0

RUN apk update && \
	apk add --no-cache nginx

RUN rm -rf /etc/nginx/nginx.conf; \
	mkdir -p /var/log/nginx; \
	mkdir -p /www/data; \
	echo "<h1>Welcome to Nginx<h1>" > /www/data/index.html

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY website /website

EXPOSE 443
EXPOSE 80
EXPOSE 9191

CMD ["nginx", "-g", "daemon off;"]
