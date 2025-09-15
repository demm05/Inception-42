#!/bin/sh

# Exit immediately if a command fails, preventing the script from continuing in a broken state.
set -e

# This script runs every time the container starts. We only want to initialize
# the database on the *first* run. We check for the existence of the 'mysql'
# database directory to determine if initialization is needed.
if [ -d "/var/lib/mysql/mysql" ]; then
	echo "[i] Database already initialized."
else
	# Ensure ownership of the data directory is correct before proceeding.
	chown -R mysql:mysql /var/lib/mysql

	echo "[i] Initializing database..."
	# Initialize the database. Suppress verbose output.
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    if [ -n "$DB_ROOT_PASSWORD_FILE" ]; then
		export DB_ROOT_PASSWORD=$(cat "$DB_ROOT_PASSWORD_FILE")
	fi
	if [ -n "$DB_PASSWORD_FILE" ]; then
		export DB_PASSWORD=$(cat "$DB_PASSWORD_FILE")
	fi

	if [ -z "$DB_ROOT_PASSWORD" ] || [ -z "$DB_DATABASE" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
		echo "[!] ERROR: One or more required environment variables are not set."
		exit 1
	fi

	# --- Database Initialization and Securing ---
	# Start the MariaDB server in the background.
	mariadbd-safe --datadir=/var/lib/mysql > /dev/null &
	pid="$!"

	# Wait for the server to be ready. Instead of a fixed 'sleep', we poll the server.
	# This is far more reliable.
	until mariadb-admin ping -h localhost --silent; do
		echo "[i] Waiting for MariaDB to be ready..."
		sleep 2
	done


	echo "[i] MariaDB is ready. Configuring users and database..."
	# Execute all setup and security commands in a single, non-interactive session.
	# This is more efficient than connecting multiple times.
	mariadb << EOF
-- Set the root password using the modern and secure ALTER USER command.
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';

-- Remove anonymous users for security.
DELETE FROM mysql.user WHERE User='';

-- Disable remote root login.
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Drop the default 'test' database.
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Create the application database and user as required by the project.
CREATE DATABASE IF NOT EXISTS \`$DB_DATABASE\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_DATABASE\`.* TO '$DB_USER'@'%';

-- Apply all changes.
FLUSH PRIVILEGES;
EOF

	# Shut down the temporary server using the new root password.
	if ! mariadb-admin -u root -p"$DB_ROOT_PASSWORD" shutdown; then
		echo "[!] Failed to shut down MariaDB gracefully. Killing process."
		kill -s TERM "$pid"
	fi
fi
# Use 'exec' to replace the script process with the MariaDB daemon.
# This makes MariaDB the main process (PID 1) of the container, which is a Docker best practice.
echo "[i] Starting MariaDB server..."
exec mariadbd-safe --datadir=/var/lib/mysql
