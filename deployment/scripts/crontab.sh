#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh
figlet "Crontab"

function add_cron(){

    NEW_CRON_ENTRY=$1;
    if ! crontab -u apache -l | grep -Fq "$NEW_CRON_ENTRY"; then
      echo "Adding new cron jobs"
      echo "" > allcrons
      crontab -u apache -l >> allcrons || true
      echo "$NEW_CRON_ENTRY" >> allcrons
      crontab -u apache allcrons
      rm -rf allcrons
    fi
}

cd $CODEDEPLOY
add_cron "* * * * * /usr/bin/php /var/www/$PROJECT/bin/magento cron:run | grep -v 'Ran jobs by schedule' >> /var/www/$PROJECT/var/log/magento.cron.log";
add_cron "* * * * * /usr/bin/php /var/www/$PROJECT/update/cron.php >> /var/www/$PROJECTo/var/log/update.cron.log";
add_cron "* * * * * /usr/bin/php /var/www/$PROJECT/bin/magento setup:cron:run >> /var/www/$PROJECT/var/log/setup.cron.log";

