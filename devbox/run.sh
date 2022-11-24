#!/usr/bin/bash

echo "ansible provisioning..."
echo "--------------------------------------"
bash /box/devbox/provision/ansible.sh || exit 1

echo

echo "crond..."
echo "--------------------------------------"
test -x /usr/sbin/crond && /usr/sbin/crond

echo

echo "starting Apache web server..."
echo "--------------------------------------"
/usr/libexec/httpd-ssl-gencerts
exec /usr/sbin/httpd -D FOREGROUND &
wait
