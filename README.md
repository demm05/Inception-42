*This project has been created as part of the 42 curriculum by dmelnyk.*

# Inception

## Description
Inception is a System Administration related project at 42. It involves setting up a small infrastructure using Docker Compose, consisting of Nginx, MariaDB, and WordPress, each running in a dedicated container. The goal is to understand containerization, system administration, and network configuration.

### Project description
This project uses Docker to create independent, containerized services (Nginx, MariaDB, WordPress) instead of polluting a single host machine with multiple applications. The sources include custom Alpine-based Dockerfiles with setup scripts designed to handle their specific daemon logic.

- **Virtual Machines vs Docker**: Virtual Machines emulate a full operating system and hardware on top of a hypervisor, which involves heavy memory and CPU overhead. Docker Containers share the host OS kernel and isolate the application processes natively, resulting in lightning-fast startups and lightweight resource usage.
- **Secrets vs Environment Variables**: Environment Variables are stored directly in process environments or plaintext files (like `.env`), making them useful for standard configuration but vulnerable if leaked. Docker Secrets inject sensitive data (passwords, keys) as temporary files strictly in memory (in `/run/secrets/`) within containers, drastically reducing the risk of credentials being logged, committed to git, or leaked globally.
- **Docker Network vs Host Network**: Host networking removes isolation and directly attaches a container to the host's network interfaces, which can lead to port conflicts and security issues. Docker Networks (used here via `bridge`) create sandboxed, internal virtual networks where containers resolve each other securely by name, minimizing the attack surface.
- **Docker Volumes vs Bind Mounts**: Bind Mounts link an exact hardcoded path on the host to the container which restricts portability but is simple to directly inspect. Docker Volumes are fully managed entirely by Docker, meaning they abstract away host paths, are safer for multi-OS compatibility, and integrate cleanly with backups. Though this project strictly mounts to `/home/login/data` due to the subject explicitly requesting it using local driver named volumes, volumes are the typical best practice over direct external binds.

## Instructions
1. **Clone the repository.**
2. **Run the project**:
   ```bash
   make all
   ```
   *Note: The Makefile automatically invokes OpenSSL to generate secure passwords purely locally and completely ignored by Git inside the `secrets/` directory if they do not exist, to perfectly comply with 42 curriculum security practices.*
3. **Access**: Open [https://dmelnyk.42.fr](https://dmelnyk.42.fr).
4. **Clean up**: `make fclean` (removes containers, networks, secrets, and all persistent data).

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Alpine Linux](https://www.alpinelinux.org/)
- **AI Usage**: AI was used to help generate the initial boilerplate for Dockerfiles, debug Nginx configuration syntax.
