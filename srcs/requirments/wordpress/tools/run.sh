#!/bin/bash

set -e
UPSTREAM_URL=https://wordpress.org/wordpress-6.8.3.tar.gz

if [ -n "$DB_PASSWORD_FILE" ]; then
	export DB_PASSWORD=$(cat "$DB_PASSWORD_FILE")
fi

if [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ] || [ -z "$DB_HOST" ]; then
	echo "[!] ERROR: One or more required environment variables are not set."
	exit 1
fi

if [ -d "/srv/www/wordpress/wp-config.php" ]; then
	echo "[i] Wordpress is already installed."
else
    mkdir -p /srv/www
    chown www-data: /srv/www

    curl -fsSL $UPSTREAM_URL | tar zx -C /srv/www
    chown www-data: /srv/www/wordpress

    SALTS=$(curl -fsSL https://api.wordpress.org/secret-key/1.1/salt/)

    cat << EOF > /srv/www/wordpress/wp-config.php 
<?php
define('DB_NAME', '$DB_NAME');
define('DB_USER', '$DB_USER');
define('DB_PASSWORD', '$DB_PASSWORD');
define('DB_HOST', '$DB_HOST');
define('WP_CONTENT_DIR', '/var/lib/wordpress/wp-content');

$SALTS

$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';

?>
EOF

    chown www-data: /srv/www/wordpress/wp-config.php

fi

php8.2-fpm -F
