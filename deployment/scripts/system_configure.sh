#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

# Zabbix
envsubst < $CODEDEPLOY/deployment/configs/zabbix_agentd.conf > /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent

# PHP config
if ! grep -q "post_max_size=64M" /etc/php.ini; then
    echo "post_max_size=64M\nupload_max_filesize=64M\nmax_input_vars=750000" >> /etc/php.ini
fi