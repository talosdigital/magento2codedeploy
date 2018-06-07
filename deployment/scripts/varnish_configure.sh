#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

function add_host(){
    if ! grep -Fq "backend $1" /etc/varnish/default.vcl; then
      echo "Adding Varnish host"
      envsubst < $CODEDEPLOY/deployment/configs/varnish-template.vcl >> /etc/varnish/default.vcl
    fi
}

add_host "$PROJECT";

systemctl reload varnish