#!/bin/bash

mkdir -p /etc/ansible
echo -e "[defaults]\ngather_timeout = 30" > /etc/ansible/ansible.cfg

export PYTHONPATH=/omd/versions/default/lib/python
export PATH=/omd/versions/default/bin:$PATH

SKIP_FILE="${SKIP_TAGS_FILE:-/src/.skip_builds}"
SKIP_TAGS=$(grep -vE '^\s*(#|$)' "$SKIP_FILE" 2>/dev/null | paste -sd, -)
EXTRA_ARGS=()
[[ -n "$skip_tags" ]] && EXTRA_ARGS+=(--skip-tags "$SKIP_TAGS")

ansible-playbook -i localhost, "${ANSIBLE_PLAYBOOK:-/box/devbox/provision/main.yml}" -c local "${EXTRA_ARGS[@]}" "$@"
exit $?

