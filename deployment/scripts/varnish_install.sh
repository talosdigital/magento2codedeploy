#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

if [ ! -f "/etc/varnish/default.vcl" ]; then
    yum install -y epel-release pygpgme yum-utils
    /bin/cp $CODEDEPLOY/deployment/configs/varnish/varnishcache_varnish5.repo /etc/yum.repos.d/varnishcache_varnish5.repo

    yum -q makecache -y --disablerepo='*' --enablerepo='varnishcache_varnish5'
    yum -y install varnish

    firewall-cmd --zone=public --add-port=6081/tcp --permanent
    firewall-cmd --reload
fi

/bin/cp $CODEDEPLOY/deployment/configs/varnish/varnish-default.vcl /etc/varnish/default.vcl
cat $CODEDEPLOY/deployment/configs/varnish/varnish-magento.vcl >> /etc/varnish/default.vcl
