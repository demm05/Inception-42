FROM alpine:3.22.0

RUN apk update && \
	apk add --no-cache mariadb mariadb-client mariadb-server-utils

COPY ./tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

# Expose the default MariaDB port
EXPOSE 3306

# Run the setup script as the main command.
CMD ["/usr/local/bin/setup.sh"]
