#!/bin/sh

set -e

if [ -f "$DB_ROOT_PASSWORD_FILE" ]; then
    DB_ROOT_PASSWORD=$(cat "$DB_ROOT_PASSWORD_FILE")
fi
if [ -f "$DB_PASSWORD_FILE" ]; then
    DB_PASSWORD=$(cat "$DB_PASSWORD_FILE")
fi

if [ -z "$DB_ROOT_PASSWORD" ] || [ -z "$DB_DATABASE" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "[!] ERROR: Required environment variables are missing."
    exit 1
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[i] Initializing database..."
    
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "[i] Starting temporary server..."
    /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
    pid="$!"
    
    until mysqladmin ping -h localhost --silent; do
        sleep 2
    done

    echo "[i] Configuring MariaDB..."
    mysql -u root << EOF
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';

-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Disable remote root login
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Drop test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Create application database and user
CREATE DATABASE IF NOT EXISTS \`$DB_DATABASE\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_DATABASE\`.* TO '$DB_USER'@'%';

FLUSH PRIVILEGES;
EOF

    echo "[i] Shutting down temporary server..."
    mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown
fi

# Ensure networking is configured to listen on all interfaces
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

echo "[i] Starting MariaDB..."
exec /usr/bin/mysqld_safe --datadir=/var/lib/mysql
