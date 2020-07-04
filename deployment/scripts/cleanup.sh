#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh
figlet "Cleanup"

rm -rf /var/www/deployment
mv /var/www/$PROJECT/deployment deployment-scripts
rm -f /var/www/codedeploy
