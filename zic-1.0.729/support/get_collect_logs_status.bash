#!/bin/bash

# Parameters:
# 1 : Case number

cd "$(dirname "$0")"

source lib/utils.bash

init

if [ "$1" == "" ]; then
    echo "Task Id is not provided. aborting"
    exit 1
fi

TASK_ID=$1

response=$(curl -sb -H "Accept: application/json" http://localhost:8082/api/LogCollectionTasks/${TASK_ID})

log_info Log collection task status:
log_important ${response}
