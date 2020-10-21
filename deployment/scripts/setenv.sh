#!/bin/bash
export CODEDEPLOY=$HOME/codedeploy

# Target
cd $CODEDEPLOY
export PROJECT=$(ls -1 target-* | sed -e 's/target-//g')
export PROJECT_NAME=$(echo $PROJECT | sed 's/\./_/g')
export PROJECT_WITHOUT_WWW=$(echo $PROJECT | sed 's/www\.//g')

# Deployment paths
export TARGET=$HOME/$PROJECT
export TMPTARGET=$CODEDEPLOY

# Web server user/group
export USER=apache
export GROUP=apache

date

. ./setenv-project.sh || true