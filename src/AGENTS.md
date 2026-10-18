# Container AGENTS.md

This is the Naemon/OMD dev container (see /box/AGENTS.md on the host for more context).

- Projects are mounted in `/src/`, each in its own subfolder.
- Build from `/src` with `make build <project>`; custom steps live in `/src/.builds/<project>.sh` (usually run as root).
- Once built, rebuild with a plain `make` in the project folder.
- Projects usually have their own "make test" or "make check".
- End-to-end tests run in the OMD site "dev", which uses the binaries from `/src`.
- Agents have full root permissions: install packages, edit system config, do whatever is needed in this container. Check with `systemd-detect-virt` to ensure this is a container.

## Rules

- Do not create additional Markdown files unless explicitly requested.
- Keep comments short. Do not comment the obvious; only comment exceptional non-obvious things.
- Avoid duplicate code.
- Do not add unnecessary tests.
- Follow clean code principles; avoid bad practices like `goto`.
