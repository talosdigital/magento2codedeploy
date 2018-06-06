#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

# Mail MTA
postconf -e "relayhost = $SMTP_SERVER"
postconf -e 'smtp_sasl_auth_enable = yes'
postconf -e 'smtp_sasl_security_options = noanonymous'
postconf -e 'smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd'
postconf -e 'smtp_use_tls = yes'
postconf -e 'smtp_tls_security_level = encrypt'
postconf -e 'smtp_tls_note_starttls_offer = yes'
postconf -e 'smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt'

/bin/cp $CODEDEPLOY/deployment/sasl_passwd /etc/postfix/sasl_passwd
postmap hash:/etc/postfix/sasl_passwd
chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
systemctl reload postfix
