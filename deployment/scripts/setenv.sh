#!/bin/bash

export CODEDEPLOY=/var/www/codedeploy

# Target
cd $CODEDEPLOY
export PROJECT=$(ls -1 target-* | sed -e 's/target-//g')
export PROJECT_NAME=$(echo $PROJECT | sed 's/\./_/g')
export PROJECT_WITHOUT_WWW=$(echo $PROJECT | sed 's/www\.//g')

# Deployment paths
export TARGET=/var/www/$PROJECT
export TMPTARGET=$CODEDEPLOY
export BACKUP=/var/www/$PROJECT-backup

# Web server user/group
export USER=apache
export GROUP=apache

# Read variables.json
for s in $(cat deployment/variables.json | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
    export $s
done
