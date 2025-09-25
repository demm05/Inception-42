if [ -n "$DB_PASSWORD_FILE" ]; then
	export DB_PASSWORD=$(cat "$DB_PASSWORD_FILE")
fi

if [ -z "$DB_DATABASE" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
	echo "[!] ERROR: One or more required environment variables are not set."
	exit 1
fi

cat << EOF > /etc/wordpress/config-$DOMAIN_NAME.php
<?php
define('DB_NAME', '$DB_NAME');
define('DB_USER', '$DB_USER');
define('DB_PASSWORD', '$DB_PASSWORD');
define('DB_HOST', 'localhost');
define('WP_CONTENT_DIR', '/var/lib/wordpress/wp-content');
?>
EOF
