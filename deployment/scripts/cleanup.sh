#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh
figlet "Cleanup"

rm -rf /var/www/$PROJECT/deployment
