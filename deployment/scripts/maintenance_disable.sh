#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh
figlet "Maintenance Disable"

cd /var/www/$PROJECT
sudo -H -u $USER bash -c "php bin/magento maintenance:disable || true"

systemctl restart varnish || true