#!/usr/bin/env bash

set -e -x

TMP_DIR=${1}

SCRIPT_DIR="$(dirname "$0")"
source ${SCRIPT_DIR}/util.sh

(
    cd ${TMP_DIR}/operator-lifecycle-manager
    kubectl apply -f deploy/upstream/manifests/latest/
    waitPodsReady
    kubectl apply -f deploy/upstream/manifests/latest/
    waitPodsReady
)
