#!/bin/bash

mkdir -p /etc/ansible
echo -e "[defaults]\ngather_timeout = 30" > /etc/ansible/ansible.cfg

export PYTHONPATH=/omd/versions/default/lib/python
export PATH=/omd/versions/default/bin:$PATH

ansible-playbook -i localhost, "/box/devbox/provision/main.yml" -c local
exit $?
