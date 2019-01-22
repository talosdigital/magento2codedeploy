#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh
figlet "System Configure"

# Zabbix
envsubst < $CODEDEPLOY/deployment/configs/zabbix_agentd.conf > /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent

# PHP
/bin/cp $CODEDEPLOY/deployment/configs/90-talos.ini /etc/php.d/90-talos.ini
