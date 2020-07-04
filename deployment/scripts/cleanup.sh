#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh
figlet "Cleanup"

# Remove deployment scripts and leave a copy for debugging
rm -rf /var/www/deployment
mv /var/www/$PROJECT/deployment ../deployment

# Remove any previous deployment
rm -f /var/www/codedeploy
