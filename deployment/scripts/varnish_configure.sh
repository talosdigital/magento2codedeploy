#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh


function add_host(){
    if ! grep -q "vcl.load $1" /etc/varnish/default.vcl; then
      echo "Adding Varnish host"
      echo "vcl.load $1 /etc/varnish/$1.vcl"
    fi
}

#if [ "$VARNISH_REDIRECT_WWW" = true ] ; then
#    envsubst < $CODEDEPLOY/deployment/configs/varnish/varnish-www-redirect.vcl > /etc/varnish/$PROJECT.vcl
#    envsubst < $CODEDEPLOY/deployment/configs/varnish/varnish-template.vcl >> /etc/varnish/$PROJECT.vcl
#else
#    envsubst < $CODEDEPLOY/deployment/configs/varnish/varnish-non-www-redirect.vcl > /etc/varnish/$PROJECT.vcl
#    envsubst < $CODEDEPLOY/deployment/configs/varnish/varnish-template.vcl >> /etc/varnish/$PROJECT.vcl
#fi
#add_host "$PROJECT";

systemctl restart varnish
