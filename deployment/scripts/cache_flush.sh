#!/bin/bash

. /var/www/codedeploy/deployment/scripts/setenv.sh

cdnArray=(${CDN//,/ })

for id in ${cdnArray[*]}; do
	aws cloudfront create-invalidation --distribution-id $id --path "/*"
done

