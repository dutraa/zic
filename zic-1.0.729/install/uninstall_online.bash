#!/bin/bash

cd "$(dirname "$0")"

source lib/utils.bash

set -e

TAG="1.0.729"
ZERTO_ROOT="/opt/zerto"
ZERTO_TMP=$ZERTO_ROOT/tmp
ZIC_ROOT=$ZERTO_ROOT/zic
ZIC_SECRETS_FOLDER="/usr/bin/secrets/zic"

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

log_info Uninstalling ZIC $TAG

log_info "Checking for unfinished recovery operations"
docker run --rm --name incloud-configuration-manager-aws -v $ZIC_ROOT/logs/:/app/logs/ zapps-registry.zerto.com/zic/stable/incloud-configuration-manager-aws:${TAG} --flow "pre-uninstall"

log_info Shutting down ZIC service
TAG=$TAG docker-compose -f $ZIC_ROOT/docker-compose.yml -f $ZIC_ROOT/docker-compose.online.yml down

log_info Deleting auxiliary cloud resources
docker run --rm --name incloud-configuration-manager-aws -v $ZIC_ROOT/logs:/app/logs/ zapps-registry.zerto.com/zic/stable/incloud-configuration-manager-aws:${TAG} --flow "post-uninstall"

log_info Deleting ZIC files
mkdir -p $ZERTO_TMP/logs
ln $ZIC_ROOT/logs/configuration_manager_logfile.csv $ZERTO_TMP/logs
rm -rf $ZIC_ROOT
mkdir -p $ZIC_ROOT
mv $ZERTO_TMP/logs $ZIC_ROOT
rm -rf $ZERTO_TMP
sudo rm -rf $ZIC_SECRETS_FOLDER

log_info ZIC $TAG uninstalled