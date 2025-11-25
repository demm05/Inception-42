#!/bin/sh

chown -R nginx:nginx /var/www/html

exec "$@"
