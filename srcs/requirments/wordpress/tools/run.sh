#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    cd /var/www/html

    wp core download --allow-root

    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --url=$DOMAIN_NAME \
        --url=localhost\
        --title=$SITE_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root

    # Create the second user (Editor/Author)
    # Fulfills requirement 
    wp user create \
        $WP_USER \
        $WP_EMAIL \
        --role=author \
        --user_pass=$WP_PASSWORD \
        --allow-root
fi

exec php-fpm82 -F
