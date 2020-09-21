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

update:
	$(MAKE) -C src update
	docker-compose pull
	for IMG in $$(grep FROM */Dockerfile | awk '{ print $$2 }' | sort -u); do docker pull $$IMG; done

clean:
	$(MAKE) -C src clean
	docker-compose kill
	docker-compose rm -f
	-docker network prune -f


prepare:
	docker-compose build
	docker-compose up --remove-orphans --scale base=0 -d
	docker ps
	@docker-compose logs -f | while read LOGLINE; do \
		echo "$${LOGLINE}"; \
		[[ "$${LOGLINE}" == *"starting Apache web server"* ]] && pkill -P $$$$ docker-compose && exit 0; \
		[[ "$${LOGLINE}" == *"ERROR"* ]] && pkill -P $$$$ docker-compose && exit 1; \
	done


shell:
	docker exec -ti "naemon-dev-box_devbox_1" env TERM=xterm bash -l
