#!/bin/sh

set -e

# Load secrets
if [ -f "$DB_PASSWORD_FILE" ]; then
    export DB_PASSWORD=$(cat "$DB_PASSWORD_FILE")
fi
if [ -f "$WP_ADMIN_PASSWORD_FILE" ]; then
    export WP_ADMIN_PASSWORD=$(cat "$WP_ADMIN_PASSWORD_FILE")
fi
if [ -f "$WP_USER_PASSWORD_FILE" ]; then
    export WP_USER_PASSWORD=$(cat "$WP_USER_PASSWORD_FILE")
fi

# Wait for MariaDB to be ready
echo "[i] Waiting for MariaDB at $DB_HOST..."
until mariadb-admin ping -h "$DB_HOST" --user="$DB_USER" --password="$DB_PASSWORD" --silent; do
    sleep 2
done
echo "[i] MariaDB is ready."

if [ ! -f /var/www/html/wp-config.php ]; then
    # Download WP-CLI if not present
    if [ ! -f /usr/local/bin/wp ]; then
        echo "[i] Installing WP-CLI..."
        wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
    fi

    echo "[i] Downloading WordPress..."
    wp core download --allow-root

    echo "[i] Creating wp-config.php..."
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --allow-root

    echo "[i] Installing WordPress..."
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    echo "[i] Creating second user..."
    wp user create \
        "$WP_USER" \
        "$WP_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root
fi

echo "[i] Starting PHP-FPM..."
exec php-fpm82 -F
