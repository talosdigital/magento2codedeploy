#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

rm -rf /var/www/$PROJECT/deployment
rm -f /var/www/codedeploy
