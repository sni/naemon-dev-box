#!/usr/bin/make -f

PROJECTS=$(shell ls -d */.git 2>/dev/null | sed 's%/.git%%' | sort)
SHELL=bash
OWNER=$(shell stat -c "%u" .)
CLONE_URLS=$(shell cat .clone_urls)
GIT_USER=sni

.DEFAULT_GOAL := help
.PHONY: help status update clean clone build
.PHONY: $(PROJECTS)

# Make sees the folder as a second goal. Consume only that explicit goal;
# validate before any recipes run, including when make is run with -j.
ifneq ($(filter build,$(MAKECMDGOALS)),)
ifneq ($(words $(MAKECMDGOALS)),2)
$(error Usage: make build <folder>)
endif
ifneq ($(firstword $(MAKECMDGOALS)),build)
$(error Usage: make build <folder>)
endif
override BUILD_PROJECT := $(patsubst %/,%,$(patsubst ./%,%,$(lastword $(MAKECMDGOALS))))
ifneq ($(findstring %,$(BUILD_PROJECT)),)
$(error Build folder must not contain a percent sign)
endif
ifneq ($(filter help status update clean clone build .builds,$(BUILD_PROJECT)),)
$(error Reserved build folder: $(BUILD_PROJECT))
endif
ifeq ($(filter $(BUILD_PROJECT)/,$(wildcard */)),)
$(error Build folder must be an existing immediate subdirectory: $(BUILD_PROJECT))
endif
export BUILD_PROJECT

build:
ifneq ($(wildcard .builds/$(BUILD_PROJECT).sh),)
	@cd "$$BUILD_PROJECT" && bash "../.builds/$$BUILD_PROJECT.sh"
else
	@cd "$$BUILD_PROJECT" && make
endif
else
# `make <project>` (without an explicit `build` goal) is shorthand for `make build <project>`.
$(PROJECTS):
	@$(MAKE) build $@
endif

build-all:
	@for p in $(PROJECTS); do \
		printf "%-30s\n" $$p; \
		$(MAKE) build $$p; \
	done

help:
	@echo "make build <folder>  # run .builds/<folder>.sh, or make in the folder"
	@echo "make status          # show status of cloned projects"
	@echo "make update          # run git pull for clean checkouts (git pull)"
	@echo "make clean           # remove untracked files and directories (git clean)"
	@echo "make clone           # clone all projects"
	@echo "make help            # show this help message"

status:
	@echo "*** status:"
	@for p in $(PROJECTS); do \
		cd $$p; \
		printf "%-30s" $$p; \
		if [ $$(git status 2>&1 | grep -cP '(working tree clean|working directory clean)') -eq 1 ]; then \
			git fetch >/dev/null 2>&1; \
			STATUS=$$(git status 2>&1); \
			ahead_re='Your branch is ahead(.*) by [0-9]+ commit[s]*.'; \
			if [[ "$$STATUS" =~ 'Changed but not updated:' ]]; then \
				echo "Dirty"; \
			elif [[ "$$STATUS" =~ 'Untracked files:' ]]; then \
				echo "Untracked files"; \
			elif [[ "$$STATUS" =~ 'Your branch is behind' ]]; then \
				echo "$$STATUS" | grep 'Your branch is behind'; \
			elif [[ "$$STATUS" =~ $$ahead_re ]]; then \
				echo $$BASH_REMATCH; \
			elif [[ "$$STATUS" =~ 'Changes to be committed:' ]]; then \
				echo "dirty"; \
			else \
				br=$$(git rev-parse --abbrev-ref HEAD 2> /dev/null); \
				if [ "$$br"  = "HEAD" ]; then \
					tag=$$(git describe --tags --exact-match 2> /dev/null); \
					if [ -n "$$tag" ]; then br="$$tag"; fi; \
				fi; \
				printf "%-10s %-10s " "ok" "$$br"; \
				printf "%-12s %-10s " $$(git log --pretty="format: %cs %h" --abbrev-commit -1); \
				printf "%s\n" "$$(git log --pretty="format: %s" --abbrev-commit -1)"; \
			fi; \
			chown -R $(OWNER) . >/dev/null 2>&1; \
		else \
			echo "dirty"; \
		fi; \
		cd ..; \
	done

update:
	@echo "*** update:"
	@for p in $(PROJECTS); do \
		cd $$p; \
		printf "%-30s" $$p; \
		if [ $$(git status 2>&1 | grep -cP '(working tree clean|working directory clean)') -eq 1 ]; then \
			git pull >/dev/null 2>&1; \
			chown -R $(OWNER) . >/dev/null 2>&1; \
			printf "%-10s %-10s" "updated" "$$(git rev-parse --abbrev-ref HEAD)"; \
			printf "%-12s %-10s" $$(git log --pretty="format: %cs %h" --abbrev-commit -1); \
			printf "%s\n" "$$(git log --pretty="format: %s" --abbrev-commit -1)"; \
		else \
			echo "dirty"; \
		fi; \
		cd ..; \
	done

clone:
	@echo "*** clone:"
	@set -e; for p in $(CLONE_URLS); do \
		case "$$p" in \
			http://*|https://*) url=$$p; path=$${p#*://} ;; \
			git@*:*) path=$${p#git@}; path=$${path/:/\/}; url=https://$$path ;; \
			*) echo "Unsupported clone URL: $$p" >&2; exit 1 ;; \
		esac; \
		host=$${path%%/*}; path=$${path#*/}; \
		owner=$${path%%/*}; repo=$${path#*/}; dir=$${repo##*/}; dir=$${dir%.git}; \
		printf "%-30s\n" $$p; \
		if [ -d "$$dir" ]; then \
			echo "  -> exists already"; \
			continue; \
		fi; \
		remote=upstream_origin; \
		if [ "$$owner" = $(GIT_USER) ]; then remote=$(GIT_USER); fi; \
		git clone --origin "$$remote" "$$url" "$$dir"; \
		git -C "$$dir" remote set-url --push "$$remote" "git@$$host:$$path"; \
		if [ "$$owner" != $(GIT_USER) ]; then \
			set +e; \
			git -C "$$dir" branch -m upstream && \
			git -C "$$dir" remote add $(GIT_USER) "$${url%%://*}://$$host/$(GIT_USER)/$$repo" && \
			git -C "$$dir" remote set-url --push $(GIT_USER) "git@$$host:$(GIT_USER)/$$repo" && \
			git -C "$$dir" fetch $(GIT_USER) && \
			git -C "$$dir" remote set-head $(GIT_USER) --auto && \
			git -C "$$dir" branch --track $(GIT_USER) $(GIT_USER)/HEAD && \
			set -e; \
		fi; \
	done

clean:
	@echo "*** clean:"
	@for p in $(PROJECTS); do \
		cd $$p; \
		printf "%-30s" $$p; \
		git clean -qxfd 2>&1; \
		chown -R $(OWNER) . >/dev/null 2>&1; \
		echo "done"; \
		cd ..; \
	done
