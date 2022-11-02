#!/bin/bash

# Parameters:
# 1 : Task id

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

log_info status = ${STATUS} COMPLETION_STATUS = ${COMPLETION_STATUS}

if [ "$STATUS" == 'Completed' ] && [ "$COMPLETION_STATUS" == 'Success' ]; then

    LOGS_LOCATION=$(echo ${RESPONSE}|jq -r '.logsLocationInContainer')

    log_info starting donwloading logs. Location of logs on host: ${LOGS_LOCATION}

    docker cp zic-support:${LOGS_LOCATION} .

    log_important finished

    log_info Please, note: you can use a remove_logs_collection_bundle.bash script to delete collected logs from support container. You must provide a task id, provided above. E.g:
    log_important sudo ./remove_logs_collection_bundle.bash ${TASK_ID}
else
    log_info Cannot start logs downloading. Either log collection failed or it yet has not been finished.
fi