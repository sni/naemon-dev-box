# Build Process

Run `make build <folder>` from the parent directory to build one project.
The folder must be an immediate subdirectory; a trailing slash is accepted.
Existing Make targets and `builds` are reserved names. Folder names containing
whitespace or Make metacharacters are unsupported.

Add `builds/<folder>.sh` for projects needing custom build steps. The dispatcher
runs it with Bash, with the project folder as its working directory. Scripts
do not need an executable bit. Use `set -euo pipefail` to stop on errors and
export project-specific variables inside the script to keep them scoped to
that build. Without a script, the dispatcher runs `make` in the project folder.
Build failures propagate to the calling Make process.
