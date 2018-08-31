#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

# Zabbix
envsubst < $CODEDEPLOY/deployment/configs/zabbix_agentd.conf > /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent
