#!/bin/bash

. /var/www/codedeploy/deployment/scripts/setenv.sh

CDN_ARRAY=(${CDN//,/ })

for ID in ${CDN_ARRAY[*]}; do
	aws cloudfront create-invalidation --distribution-id $ID --path "/*"
done

