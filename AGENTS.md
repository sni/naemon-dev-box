# Naemon Development Container Setup

This is a docker(-compose) setup for developing Naemon and OMD (Open Monitoring Distribution) related software projects.
The idea is to mount the projects from the `/src/` folder into the container and rebuild them inside the container. There
is OMD site `dev` which then uses the binaries from the `/src` folder.

## Basic Information

- **./devbox/** Contains playbooks and scripts to provision the container.
- **./src/**    Contains the individual software projects.
                The projects are initially configured and compiled already during provisioning.
                Rebuilding usually done by `make` in the `/src/<project>` subfolder from inside the container.

## Rules

- Every build or test is supposed to run in the container.
