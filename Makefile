#!/usr/bin/make -f

SHELL=bash

help:
	@echo "make help"
	@echo "make status|update|build|clean"
	@echo "make prepare|update|shell"

build:
	$(MAKE) -C src build

status:
	$(MAKE) -C src status

update: trychown
	$(MAKE) -C src update
	docker compose pull
	for IMG in $$(grep FROM */Dockerfile | awk '{ print $$2 }' | sort -u); do docker pull $$IMG; done

clean: trychown
	$(MAKE) -C src clean
	docker compose kill
	docker compose rm -f
	-docker network prune -f


prepare:
	docker compose build
	$(MAKE) up

up:
	docker compose up --remove-orphans -d
	docker ps
	@while read LOGLINE; do \
		echo "$${LOGLINE}"; \
		[[ "$${LOGLINE}" == *"starting Apache web server"* ]] && exit 0; \
		[[ "$${LOGLINE}" == *"ERROR"* ]] && exit 1; \
	done < <(docker compose logs -f)

stop:
	docker compose stop

start:
	docker compose start
	docker ps

shell:
	docker exec -ti "naemon-dev-box_devbox_1" env TERM=xterm bash -l

trychown:
	-sudo chown $$USER: -R src/
