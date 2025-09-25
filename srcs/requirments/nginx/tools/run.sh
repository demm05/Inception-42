
RUN mkdir -p /var/log/nginx && chown -R www:www /var/log/nginx; \
	mkdir -p /www/data && chown -R www:www /www; \
	chown -R www:www /var/lib/nginx; \
	mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig

exec nginx -g "daemon off;" "$@"
