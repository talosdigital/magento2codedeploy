#!/bin/bash
. /setenv.sh
figlet "Maintenance Enable" || true

cd $TARGET
sudo -H -u $USER bash -c "php bin/magento maintenance:enable || true"


