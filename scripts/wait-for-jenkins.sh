#!/bin/bash
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ -n "${GOOGLE_APPLICATION_CREDENTIALS}" ]; then
    export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=${GOOGLE_APPLICATION_CREDENTIALS}
fi

PROJECT=$1
ZONE=$2
INSTANCE_NAME=$3
COMMAND="ls /tmp/instance_setup_complete"

echo "Waiting for instance ${INSTANCE_NAME} in project ${PROJECT} to complete..."

gcloud compute --project "${PROJECT}" ssh "cftk@${INSTANCE_NAME}" --zone "${ZONE}" --command="${COMMAND}" --force-key-file-overwrite 2>/dev/null
rc=$?

while [[ "${rc}" -ne "0" ]]; do
    printf "."
    sleep 5
    gcloud compute --project "${PROJECT}" ssh "cftk@${INSTANCE_NAME}" --zone "${ZONE}" --command="${COMMAND}" --force-key-file-overwrite 2>/dev/null
    rc=$?
done

echo "Instance is ready!"
