# Inception-42 Developer Documentation

## Architecture
The project consists of 3 isolated Docker containers:
1. **MariaDB**: Stores the WordPress database.
    - Dockerfile: `srcs/requirements/mariadb/Dockerfile`
    - Port: 3306 (Internal only)
2. **WordPress + PHP-FPM**: The application logic.
    - Dockerfile: `srcs/requirements/wordpress/Dockerfile`
    - Port: 9000 (Internal only)
3. **Nginx**: The web server and TLS terminator.
    - Dockerfile: `srcs/requirements/nginx/Dockerfile`
    - Port: 443 (Mapped to host 8443 for local testing)

## Directory Structure
```
.
├── Makefile            # Automation commands
├── secrets/            # Sensitive passwords
└── srcs/
    ├── docker-compose.yml
    ├── .env            # Configuration variables
    └── requirements/   # specific service configurations
```

## Data Persistence
Data is stored on the host machine in the following directories:
- `/home/dmelnyk/data/mariadb`: Database files
- `/home/dmelnyk/data/wordpress`: WordPress site files

These are mounted as named volumes using the `local` driver with `driver_opts` type `none` and `o: bind`.

## Development Commands
- `make build`: Rebuilds the Docker images without starting.
- `make clean`: Stops containers and prunes images.
- `make fclean`: **WARNING** - Deletes all containers, images, AND data in `/home/dmelnyk/data`.
- `make re`: Full rebuild and restart.

## Troubleshooting
- **Logs**: `docker logs <container_name>` (e.g., `docker logs wordpress`)
- **Shell Access**: `docker exec -it <container_name> /bin/sh`
