#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh

echo "Deployment $TMPTARGET >>> $TARGET"

echo "Required symbolic links and permissions"
cd $TMPTARGET
mkdir -p $TARGET/../env/$PROJECT/media; chown $USER:$GROUP $TARGET/../env/$PROJECT/media;
mkdir -p $TARGET/../env/$PROJECT/var; chown $USER:$GROUP $TARGET/../env/$PROJECT/var;
find $TMPTARGET -type d -exec chmod 775 {} \;
find $TMPTARGET -type f -exec chmod 664 {} \;
chown -R $USER:$GROUP $TMPTARGET $TARGET/../env/$PROJECT/var/*

echo "Files replacement"
rm -rf --preserve-root $BACKUP
mv $TARGET $BACKUP
mv $TMPTARGET $TARGET
ln -s $TARGET $CODEDEPLOY
cd $TARGET
rm -rf var; sudo -H -u $USER bash -c "ln -s $TARGET/../env/$PROJECT/var ./var  || true"

echo "Media merge"
cd $TARGET
rsync -arv pub/media/* $TARGET/../env/$PROJECT/media
rm -rf pub/media; sudo -H -u $USER bash -c "ln -s $TARGET/../env/$PROJECT/media ./pub/media  || true"

# SELINUX security
sudo chcon -t httpd_sys_content_t $TARGET -R
sudo chcon -t httpd_sys_rw_content_t $TARGET/../env/$PROJECT/ $TARGET/generated/ $TARGET/pub/static/ -R

echo "Composer auth.json"
cd $TARGET
mv -f $TARGET/deployment/auth.json /var/www/.composer/auth.json
chown $USER:$GROUP /var/www/.composer/auth.json

echo "Dependencies"
# WORKAROUND
# https://github.com/magento/magento2/issues/6419
cd $TARGET
/bin/cp ./pub/errors/default/503.phtml ./pub/errors/default/503.phtml.backup
###
cd $TARGET
sudo -H -u $USER bash -c "composer install --no-dev"
cd update
sudo -H -u $USER bash -c "composer install --no-dev"

cd $TARGET
mv -f $TARGET/deployment/configs/htaccess-media ./pub/media/.htaccess
mv -f $TARGET/deployment/configs/htaccess-static ./pub/static/.htaccess
mv -f $TARGET/deployment/configs/htaccess-pub ./pub/.htaccess

# WORKAROUND
mv -f ./pub/errors/default/503.phtml.backup ./pub/errors/default/503.phtml
chown $USER:$GROUP ./pub/errors/default/503.phtml
###

chown $USER:$GROUP .htaccess ./pub/.htaccess ./pub/static/.htaccess ./pub/media/.htaccess

echo "Flush cache"
cd $TARGET
sudo rm -rf generated/* var/cache var/di var/generation var/page_cache

echo "Setup upgrade"
cd $TARGET
chmod a+x ./bin/magento
sudo -H -u $USER bash -c "./bin/magento setup:upgrade"

echo "Production mode"
sudo -H -u $USER bash -c "./bin/magento deploy:mode:set production -s"
sudo -H -u $USER bash -c "./bin/magento setup:di:compile"
sudo rm -rf pub/static/* var/view_preprocessed
sudo -H -u $USER bash -c "./bin/magento setup:static-content:deploy"
sudo -H -u $USER bash -c "./bin/magento cache:flush"
sudo -H -u $USER bash -c "./bin/magento deploy:mode:show"
sudo -H -u $USER bash -c "./bin/magento cache:enable"

# Varnish config
sudo -H -u $USER bash -c "bin/magento setup:config:set --http-cache-hosts=127.0.0.1:6081"

echo "Potato extension"
cd $TARGET
sudo -H -u $USER bash -c "rm -rf pub/static/_po_compressor; mkdir -p pub/static/_po_compressor";

echo "Healthcheck file"
cp $TARGET/deployment/configs/healthcheck.html $TARGET/
cp $TARGET/deployment/configs/healthcheck.html $TARGET/pub/

figlet -f banner 'HURRAY!!!!!!'