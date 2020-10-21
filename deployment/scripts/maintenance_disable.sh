#!/bin/bash
. /setenv.sh
figlet "Maintenance Disable" || true

cd $TARGET
sudo -H -u $USER bash -c "php bin/magento maintenance:disable || true"
