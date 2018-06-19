#!/bin/bash

# System update
yum -y update

# Required Software
yum -y install \
    git figlet gcc-c++ nfs-utils \
    awscli firewalld mariadb psmisc \
    mailx bzip2 cyrus-sasl-plain telnet \
    redis patch goaccess net-snmp \
    openssl-devel xinetd unzip jq


# Firewall
systemctl start firewalld

# Install Apache
yum -y install httpd mod_ssl openssl
systemctl enable httpd.service
usermod -d /var/www apache
systemctl start httpd

# Install PHP 7 and Modules
yum install -y http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm
yum -y update
yum -y install php71u php71u-pdo php71u-mysqlnd \
    php71u-opcache php71u-xml php71u-mcrypt \
    php71u-gd php71u-devel php71u-mysql \
    php71u-intl php71u-mbstring php71u-bcmath \
    php71u-json php71u-iconv php71u-soap

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer
mkdir -p /var/www/.composer
chown apache:apache /var/www/.composer

# PHP Settings
sed -i 's/memory_limit = 128M/memory_limit = -1/g' /etc/php.ini 
sed -i 's/;date.timezone =/date.timezone = America\/Bogota/g' /etc/php.ini

# Timezone
mv /etc/localtime /etc/localtime.bak
ln -s /usr/share/zoneinfo/America/Bogota /etc/localtime

# Add welcome message
function add_welcome_message(){
    MESSAGE="figlet $1;";
    if ! grep -q "$MESSAGE" /home/centos/.bash_profile; then
      echo $MESSAGE >> /home/centos/.bash_profile
    fi
}
add_welcome_message $DEPLOYMENT_GROUP_NAME

# CodeDeploy log access
ln -sfn /opt/codedeploy-agent/deployment-root/deployment-logs/codedeploy-agent-deployments.log /home/centos/codedeploy-agent-deployments.log

# Zabbix
if [ ! -f "/etc/zabbix/zabbix_agentd.conf" ]; then
    rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
    yum -y install zabbix-agent
    firewall-cmd --zone=public --add-port=10050/tcp --permanent
    firewall-cmd --reload
fi

# Remove any previous deployment
rm -rf /var/www/codedeploy
