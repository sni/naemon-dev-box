#!/usr/bin/make -f

PROJECTS=$(shell ls -d */.git | sed 's%/.git%%')
SHELL=bash

help:
	@echo "make status|update|help"

build:
	@echo "*** building:"
	@for p in $(PROJECTS); do \
		cd $$p; \
		printf "%-25s" $$p; \
		if [ $$(git status 2>&1 | grep -cP '(working tree clean|working directory clean)') -eq 1 ]; then \
			make >/dev/null 2>&1; \
			echo "ok"; \
		else \
			echo "dirty"; \
		fi; \
		cd ..; \
	done

status:
	@echo "*** status:"
	@for p in $(PROJECTS); do \
		cd $$p; \
		printf "%-25s" $$p; \
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
				echo "ok"; \
			fi; \
		else \
			echo "dirty"; \
		fi; \
		cd ..; \
	done

update:
	@echo "*** update:"
	@for p in $(PROJECTS); do \
		cd $$p; \
		printf "%-25s" $$p; \
		if [ $$(git status 2>&1 | grep -cP '(working tree clean|working directory clean)') -eq 1 ]; then \
			git pull >/dev/null 2>&1; \
			echo "updated"; \
		else \
			echo "dirty"; \
		fi; \
		cd ..; \
	done
