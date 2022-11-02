#!/bin/bash

# Parameters:
# 1 : Task Id

cd "$(dirname "$0")"

source lib/utils.bash

init

if [ "$1" == "" ]; then
    echo "Task Id is not provided. aborting"
    exit 1
fi

TASK_ID=$1

RESPONSE=$(curl -sb -H "Accept: application/json" http://localhost:8082/api/LogCollectionTasks/${TASK_ID})

STATUS=$(echo ${RESPONSE}|jq -r '.taskStatus')
COMPLETION_STATUS=$(echo ${RESPONSE}|jq -r '.taskCompletionStatus')

if [ "$STATUS" == 'Completed' ] && [ "$COMPLETION_STATUS" == 'Success' ]; then

    LOGS_LOCATION=$(echo ${RESPONSE}|jq -r '.logsLocationInContainer')

    log_important starting removal logs bundle. Location of logs on host: ${LOGS_LOCATION}

    docker exec zic-support rm -rf ${LOGS_LOCATION}

    log_important finished
else
    log_info Cannot remove log bundle from service. Either log collection failed or it yet has not been finished.
fi