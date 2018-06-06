#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

cd /var/www/$PROJECT
sudo -H -u $USER bash -c "php bin/magento maintenance:disable || true"

systemctl restart varnish