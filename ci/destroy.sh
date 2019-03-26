#!/usr/bin/env bash

set -e
set -o pipefail

BASEDIR=$(dirname "$0")
MY_IP=$(curl ifconfig.co)

if [ -z "${EXAMPLE_DIR}" ]; then
    echo "Please set environment variable EXAMPLE_DIR"
    exit 1
fi
if [ -z "${TEAM_NAME}" ]; then
    echo "Please set environment variable TEAM_NAME"
    exit 1
fi


### Destroy ###
pushd "./${EXAMPLE_DIR}" > /dev/null

terraform destroy \
  -auto-approve \
  -var "teamName=${TEAM_NAME}" \
  -var "myIp=${MY_IP}"

popd > /dev/null
