#!/bin/bash

cd "$(dirname "$0")"

source lib/utils.bash

set -e

TAG="1.0.729"
ZIC_ROOT="/opt/zerto/zic"

cp -r runtime/* $ZIC_ROOT
sudo chmod -R 775 $ZIC_ROOT

ZAPPS_USERNAME=$1
if [ "$1" == "" ]; then
    echo please enter your ZAPPS username
    read ZAPPS_USERNAME
fi

ZAPPS_PASSWORD=$2
if [ "$2" == "" ]; then
    echo please enter your ZAPPS password
    read ZAPPS_PASSWORD
fi

REGISTRY_URI="zapps-registry.zerto.com"
echo "${ZAPPS_PASSWORD}" | docker login --username "${ZAPPS_USERNAME}" --password-stdin $REGISTRY_URI

create_za_hashed_license_secret $ZAPPS_USERNAME $ZAPPS_PASSWORD

log_info Upgrading ZIC $TAG
TAG=$TAG docker-compose -f $ZIC_ROOT/docker-compose.yml -f $ZIC_ROOT/docker-compose.online.yml up -d
log_info ZIC $TAG upgraded