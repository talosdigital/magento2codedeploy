#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh
figlet "Varnish Configure"

cat $CODEDEPLOY/varnish.vcl >> /etc/varnish/default.vcl

systemctl restart varnish