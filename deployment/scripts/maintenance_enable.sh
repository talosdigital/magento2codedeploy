#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

cd /var/www/$PROJECT
sudo -H -u $USER bash -c "php bin/magento maintenance:enable || true"

systemctl restart varnish