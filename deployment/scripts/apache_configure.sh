#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh
figlet "Apache Configure"

# DocumentRoot
mkdir -p /var/www
chown apache:apache /var/www
chmod 755 /var/www

# Apache Config
mkdir -p /etc/httpd/sites-available
mkdir -p /etc/httpd/sites-enabled
/bin/cp $CODEDEPLOY/deployment/configs/talos.conf /etc/httpd/conf.d/talos.conf
envsubst < $CODEDEPLOY/deployment/configs/default.conf > /etc/httpd/sites-available/default.conf
envsubst < $CODEDEPLOY/deployment/configs/template.conf > /etc/httpd/sites-available/$PROJECT.conf
ln -sfn /etc/httpd/sites-available/default.conf /etc/httpd/sites-enabled/default.conf
ln -sfn /etc/httpd/sites-available/$PROJECT.conf /etc/httpd/sites-enabled/$PROJECT.conf

#SELINUX
setsebool -P httpd_can_network_connect_db=1
setsebool -P httpd_can_network_connect=1
setsebool -P httpd_can_sendmail=1

#Add Firewall Rule for PROD Website
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --zone=public --add-port=80/tcp --permanent

# Server utils
mkdir -p /var/www/server
echo "<?php phpinfo();" > /var/www/server/test.php
/bin/cp $CODEDEPLOY/deployment/configs/healthcheck.html /var/www/server/
echo "sudo goaccess /var/log/httpd/$PROJECT-access.log -o /var/www/server/goaccess.html  --log-format=COMBINED --real-time-html" > /home/centos/goaccess-$PROJECT.sh
chmod a+x /home/centos/goaccess-$PROJECT.sh
firewall-cmd --zone=public --add-port=7890/tcp --permanent

# Ready to go!
firewall-cmd --reload
systemctl reload httpd
