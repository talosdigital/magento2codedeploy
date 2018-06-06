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

# Install Apache
yum -y install httpd mod_ssl openssl
systemctl enable httpd.service
usermod -d /var/www apache
systemctl start httpd

# Install PHP 7 and Modules
yum install -y http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-14.ius.centos7.noarch.rpm
yum -y update
yum -y install php70u php70u-pdo php70u-mysqlnd \
    php70u-opcache php70u-xml php70u-mcrypt \
    php70u-gd php70u-devel php70u-mysql \
    php70u-intl php70u-mbstring php70u-bcmath \
    php70u-json php70u-iconv php70u-soap

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer

# PHP Settings
sed -i 's/memory_limit = 128M/memory_limit = -1/g' /etc/php.ini 
sed -i 's/;date.timezone =/date.timezone = America\/Bogota/g' /etc/php.ini

# Timezone
mv /etc/localtime /etc/localtime.bak
ln -s /usr/share/zoneinfo/America/Bogota /etc/localtime

# Add welcome message
function add_welcome_message(){
    MESSAGE="figlet $1;";
    if ! cat /home/centos/.bash_profile | fgrep -q "$MESSAGE"; then
      echo $MESSAGE >> /home/centos/.bash_profile
    fi
}
add_welcome_message $DEPLOYMENT_GROUP_NAME

# CodeDeploy log access
ln -sfn /opt/codedeploy-agent/deployment-root/deployment-logs/codedeploy-agent-deployments.log /home/centos/codedeploy-agent-deployments.log

# Nagios XI
#if [ -d "/usr/local/nagiosx" ]; then
#    cd /tmp
#    wget http://assets.nagios.com/downloads/nagiosxi/agents/linux-nrpe-agent.tar.gz
#    tar xzf linux-nrpe-agent.tar.gz
#    cd linux-nrpe-agent
#    sed -i 's/read -p "Allow from:  " ALLOW_INPUT/#read -p "Allow from:  " ALLOW_INPUT/g' subcomponents/install
#    ./fullinstall -n
#    firewall-cmd --zone=public --add-port=5666/tcp --permanent
#    firewall-cmd --reload
#fi

# Zabbix
if [ ! -f "/etc/zabbix/zabbix_agentd.conf" ]; then
    rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm
    yum -y install zabbix-agent
    envsubst < $CODEDEPLOY/deployment/configs/zabbix_agentd.conf > /etc/zabbix/zabbix_agentd.conf
    firewall-cmd --zone=public --add-port=10050/tcp --permanent
    firewall-cmd --reload
    systemctl restart zabbix-agent
fi

# Remove any previous deployment
rm -rf /var/www/codedeploy