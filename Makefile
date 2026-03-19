name = inception

SECRETS_DIR = ./secrets
SECRETS = $(SECRETS_DIR)/db_password.txt $(SECRETS_DIR)/db_root_password.txt $(SECRETS_DIR)/wp_admin_password.txt $(SECRETS_DIR)/wp_user_password.txt

all: $(SECRETS)
	@mkdir -p /home/dmelnyk/data/wordpress
	@mkdir -p /home/dmelnyk/data/mariadb
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

$(SECRETS_DIR)/%.txt:
	@mkdir -p $(SECRETS_DIR)
	@openssl rand -base64 12 > $@
	@echo "Generated secret for $@"

build: $(SECRETS)
	@docker-compose -f ./srcs/docker-compose.yml build

down:
	@docker-compose -f ./srcs/docker-compose.yml down

re: fclean all

clean:
	@docker-compose -f ./srcs/docker-compose.yml down -v
	@docker system prune -af

fclean: clean
	@docker run --rm -v /home/dmelnyk/data:/data alpine sh -c "rm -rf /data/*" 2>/dev/null || true
	@rm -f $(SECRETS)
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

.PHONY: all build down re clean fclean
