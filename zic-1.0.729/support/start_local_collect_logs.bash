#!/bin/bash

# Parameters:
# 1 : Case number

cd "$(dirname "$0")"

source lib/utils.bash

init

if [ "$1" == "" ]; then
    echo "Case number is not provided. aborting"
    exit 1
fi

CASE_NUMBER=$1

RESP_LOCATION_HEADER=$(curl -d '{"caseNumber":"'${CASE_NUMBER}'", "collectOnlyCurrentRegionDbData":false}' -H "Content-Type: application/json" -X POST http://localhost:8082/api/LogCollectionTasks/local -si  | grep -oP 'Location: .*')

log_info 'Local log collection task started. TaskId:'
log_important ${RESP_LOCATION_HEADER##*/}

log_info You can use a get_collect_logs_status.bash script to check a status of log collection. You must provide a task id, provided above. E.g:

log_important ./get_collect_logs_status.bash ${RESP_LOCATION_HEADER##*/}

log_info Also, when log collection completes, you can use a download_local_logs.bash script to download collected logs. You must provide a task id, provided above. E.g:

log_important sudo ./download_local_logs.bash ${RESP_LOCATION_HEADER##*/}

log_info Also, when log collection completes, you can use a remove_logs_collection_bundle.bash script to delete collected logs from support container. You must provide a task id, provided above. E.g:

log_important sudo ./remove_logs_collection_bundle.bash ${RESP_LOCATION_HEADER##*/}