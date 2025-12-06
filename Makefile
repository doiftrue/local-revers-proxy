-include Makefile-extend.mk

# Handle `$ make` run without target
.DEFAULT_GOAL := help
help: ## Display this help screen
	@grep -h -E '^[a-zA-Z0-9._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


# If `ip -4 addr show eth0` works, the IP of eth0 is taken (WSL case). Eg: 172.27.205.45
# If the command/interface does not exist use 127.0.0.1 (ubuntu/mac case).
IS_WSL := $(shell ip -4 addr show eth0 >/dev/null 2>&1 && echo 1 || echo 0)
WSL_IP := $(shell ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# $(if cond, then, else)
docker_compose := $(if $(filter 1,$(IS_WSL)), \
  PROXIED_HOST_IP=$(WSL_IP) docker compose -f docker-compose.yml -f docker-compose.wsl.yml, \
  docker compose \
)

d.up: ## Start the proxy
	$(docker_compose) up -d

d.down: ## Stop the proxy and remove containers
	$(docker_compose) down --remove-orphans

d.recreate: ## Recreate all containers
	$(docker_compose) up --no-deps -d --force-recreate

d.rebuild: ## Rebuild all containers
	$(docker_compose) up --no-deps -d --build

d.config: ## Validate and view the resulted docker compose launch config (file)
	$(docker_compose) config

nginx.connnect: ## Connect to nginx container
	$(docker_compose) exec nginx sh

nginx.logs: ## Show nginx container logs (with follow)
	$(docker_compose) logs -f nginx

