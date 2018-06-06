#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

function add_host(){
    if ! cat /etc/varnish/default.vcl | fgrep -q "$1"; then
      envsubst < $CODEDEPLOY/deployment/configs/varnish-template.vcl >> /etc/varnish/default.vcl
    fi
}

add_host "$PROJECT";

systemctl reload varnish