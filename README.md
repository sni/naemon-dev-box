# Naemon Dev Box

This repository provides a Docker-based development container for Naemon, OMD
and related monitoring projects. It mounts the checked-out source trees into a
containerized environment so you can build, test and debug code without
polluting the host system.

This repo is intended as a development environment rather than a production
deployment.

## Overview

The dev box is organized around three layers:

- Docker Compose defines the container and network layout.
- The root Makefile controls the lifecycle of the container and the project sources.
- The [src](src) directory contains the monitored projects and the new build-dispatch system.

A OMD `mon` site is created by default, plus a `dev` site that runs Naemon and references the work in `/src`.

## Quick start

You need Docker and Docker Compose available on the host.

    git clone https://github.com/sni/naemon-dev-box.git
    cd naemon-dev-box
    make clean
    make update
    make prepare
    make shell

The container is reachable on the Docker bridge network at `192.168.99.99` and
the OMD web interfaces are typically available at:

- https://192.168.99.99/mon/
- https://192.168.99.99/dev/

The default credentials for the OMD sites are the usual OMD user setup
(`omdadmin` / `omd` for the `mon` site unless the provisioning config changed).

## Container lifecycle

The root Makefile is the main entry point for working with the dev box:

- `make prepare` builds the devbox image and starts the container
- `make stop` and `make start` manage the container lifecycle
- `make shell` opens a shell inside the devbox
- `make clean` removes generated containers and cleans projects in `/src` with git clean.
- `make update` pulls the latest container image references and refreshes the project checkout state
- `make status` show git status of the projects in `/src`

The actual container definition is in [docker-compose.yml](docker-compose.yml).
It mounts the workspace at `/box` and the source tree at `/src`, and gives the
container a fixed IP of `192.168.99.99` on the default Docker network.

## Build system

The build system lives under [src/Makefile](src/Makefile) and is designed to
build each project in the same way, with per-project overrides when a project
needs custom steps.

Projects will be build automatically when the container is prepared.
In case you want to rebuild a project later, this can be done from *inside*
the container in the `/src` directory:

    make build <folder>

Examples:

    cd /src
    make build naemon-core
    make build naemon-livestatus

This looks for a matching project directory and then either:

- runs `make` in that project if no custom hook exists, or
- runs a custom script under `.builds/<project>.sh` when that project has a special build flow.

The behaviour is defined in [src/Makefile](src/Makefile) and the build helpers
are documented in [src/.builds/README.md](src/.builds/README.md).

### Special cases via `.builds`

Some projects need non-standard build commands or environment variables. Instead
of forcing every project into the same recipe, the repository adds
project-specific scripts in [src/.builds](src/.builds).

This keeps the common case simple while allowing custom workarounds where required.

### Project-wide operations

The `/src` folder Makefile also supports:

- `make status` to show repo status for all checked-out projects
- `make update` to pull updates for clean repositories
- `make clean` to run `git clean -xfd` across the projects
- `make clone` to clone all repositories from the configured URL list
- `make build-all` to build every project in sequence

## The skel folder

The [skel](skel) directory is a template for files that are copied into the root
home directory of the devbox container during provisioning. This is controlled
in [devbox/provision/main.yml](devbox/provision/main.yml).

The sync occurs during Ansible provisioning so the container starts with a
consistent root shell environment for development.

In other words, `skel` is the repo-managed bootstrap layer for the container
root account: it seeds the shell environment, editor preferences, and optional
tooling without needing manual setup after the container is created.

### Provisioning customization

It is possible to extend the provisioning by adding `.autostart_*.sh` into the
[skel](skel) folder. They will be run before the normal projects.

To re-run the provisioning after changing configuration or adding packages:

    bash /box/devbox/provision/ansible.sh
