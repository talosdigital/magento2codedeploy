#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

cat $CODEDEPLOY/varnish.vcl >> /etc/varnish/default.vcl

systemctl restart varnish