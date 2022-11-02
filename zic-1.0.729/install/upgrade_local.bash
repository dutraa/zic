#!/bin/bash

cd "$(dirname "$0")"

source lib/utils.bash

set -e

TAG="1.0.729"
ZIC_ROOT="/opt/zerto/zic"

cp -r runtime/* $ZIC_ROOT
sudo chmod -R 775 $ZIC_ROOT

AWS_PATH=$1
if [ "$1" == "" ]; then
    echo please enter the full path of incloud-aws-${TAG}.tar
    read AWS_PATH
fi

/opt/zerto/zlinux/load_image.bash $AWS_PATH
/opt/zerto/zlinux/push_images.bash incloud-aws:$TAG incloud-aws:$TAG

GUI_PATH=$2
if [ "$2" == "" ]; then
    echo please enter the full path of incloud-gui-${TAG}.tar
    read GUI_PATH
fi

/opt/zerto/zlinux/load_image.bash $GUI_PATH
/opt/zerto/zlinux/push_images.bash incloud-gui:$TAG incloud-gui:$TAG

SUPPORT_PATH=$3
if [ "$3" == "" ]; then
    echo please enter the full path of incloud-support-${TAG}.tar
    read SUPPORT_PATH
fi

/opt/zerto/zlinux/load_image.bash $SUPPORT_PATH
/opt/zerto/zlinux/push_images.bash incloud-support:$TAG incloud-support:$TAG

CONFIGURATION_MANAGER_PATH=$4
if [ "$4" == "" ]; then
    echo please enter the full path of incloud-configuration-manager-aws-${TAG}.tar
    read CONFIGURATION_MANAGER_PATH
fi

/opt/zerto/zlinux/load_image.bash $CONFIGURATION_MANAGER_PATH
/opt/zerto/zlinux/push_images.bash incloud-configuration-manager-aws:$TAG incloud-configuration-manager-aws:$TAG

ZA_REPORTER_PATH=$5
if [ "$5" == "" ]; then
    echo please enter the full path of incloud-za-reporter-${TAG}.tar
    read ZA_REPORTER_PATH
fi

/opt/zerto/zlinux/load_image.bash $ZA_REPORTER_PATH
/opt/zerto/zlinux/push_images.bash incloud-za-reporter:$TAG incloud-za-reporter:$TAG

echo please enter your ZAPPS username
read ZAPPS_USERNAME

echo please enter your ZAPPS password:
read ZAPPS_PASSWORD

create_za_hashed_license_secret $ZAPPS_USERNAME $ZAPPS_PASSWORD

log_info Starting ZIC $TAG
TAG=$TAG docker-compose -f $ZIC_ROOT/docker-compose.yml -f $ZIC_ROOT/docker-compose.local.yml up -d
log_info ZIC $TAG started