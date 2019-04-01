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
if [ -z "${SSH_PUBLIC_KEY_PATH}" ]; then
    echo "Please set environment variable SSH_PUBLIC_KEY_PATH"
    exit 1
fi


### Deploy ###
pushd "./${EXAMPLE_DIR}" > /dev/null

terraform init

terraform plan \
  -var "teamName=${TEAM_NAME}" \
  -var "myIp=${MY_IP}" \
  -var "publicSshKeyPath=${SSH_PUBLIC_KEY_PATH}" \
  -out plan.out

terraform apply plan.out

popd > /dev/null
