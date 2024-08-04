-include Makefile-extend.mk

d.up:
	docker compose up -d

d.down:
	docker compose down --remove-orphans

d.recreate:
	docker compose up --no-deps -d --force-recreate

d.rebuild:
	docker compose up --no-deps -d --build

nginx.connnect:
	docker compose exec nginx sh

log.nginx:
	docker compose logs -f nginx

