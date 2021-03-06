#!/bin/bash
. /var/www/codedeploy/deployment/scripts/setenv.sh
figlet "Cache Flush"

CDN_ARRAY=(${CDN//,/ })

for ID in ${CDN_ARRAY[*]}; do
	aws cloudfront create-invalidation --distribution-id $ID --path "/*" || true
done

