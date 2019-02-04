#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh
figlet "Maintenance Enable"

cd /var/www/$PROJECT
sudo -H -u $USER bash -c "php bin/magento maintenance:enable || true"

systemctl restart varnish || true