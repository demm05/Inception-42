# Inception-42 User Documentation

## Overview
This project sets up a LEMP stack (Linux, Nginx, MariaDB, PHP-FPM) running WordPress using Docker Compose/Alpine Linux.

## Quick Start
1. **Prerequisites**: Ensure Docker and Make are installed.
2. **Start the project**:
   ```bash
   make all
   ```
   This will build the images and start the containers.

3. **Stop the project**:
   ```bash
   make down
   ```

## Accessing the Application
- **Website**: [https://dmelnyk.42.fr:443](https://dmelnyk.42.fr:443) (or `https://localhost:443` if hosts file not configured)
- **Admin Panel**: [https://dmelnyk.42.fr:443/wp-admin](https://dmelnyk.42.fr:443/wp-admin)

## Credentials
Credentials are stored securely in `srcs/.env` and `secrets/` directory.
- **WordPress Admin User**: `dmelnyk_admin`
- **WordPress Editor User**: `editor_user`
- **Database User**: `wordpress`

## Checking Status
To check if all services are running:
```bash
docker-compose -f srcs/docker-compose.yml ps
```
