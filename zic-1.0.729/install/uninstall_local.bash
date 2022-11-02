#!/bin/bash

cd "$(dirname "$0")"

source lib/utils.bash

set -e

TAG="1.0.729"
ZERTO_ROOT="/opt/zerto"
ZERTO_TMP=$ZERTO_ROOT/tmp
ZIC_ROOT=$ZERTO_ROOT/zic
ZIC_SECRETS_FOLDER="/usr/bin/secrets/zic"

log_info Uninstalling ZIC $TAG

log_info "Checking for unfinished recovery operations"
docker run --rm --name incloud-configuration-manager-aws -v $ZIC_ROOT/logs/:/app/logs/ localhost:5000/incloud-configuration-manager-aws:${TAG} --flow "pre-uninstall"

log_info Shutting down ZIC service
TAG=$TAG docker-compose -f $ZIC_ROOT/docker-compose.yml -f $ZIC_ROOT/docker-compose.local.yml down

log_info Deleting auxiliary cloud resources
docker run --rm --name incloud-configuration-manager-aws -v $ZIC_ROOT/logs/:/app/logs/ localhost:5000/incloud-configuration-manager-aws:${TAG} --flow "post-uninstall"

log_info Deleting ZIC files
mkdir -p $ZERTO_TMP/logs
ln $ZIC_ROOT/logs/configuration_manager_logfile.csv $ZERTO_TMP/logs
rm -rf $ZIC_ROOT
mkdir -p $ZIC_ROOT
mv $ZERTO_TMP/logs $ZIC_ROOT
rm -rf $ZERTO_TMP

log_info ZIC $TAG uninstalled