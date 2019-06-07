#!/usr/bin/env bash

set -e -x

NAMESPACE=${1}

SCRIPT_DIR="$(dirname "$0")"
source ${SCRIPT_DIR}/util.sh

kubectl create ns ${NAMESPACE} || true
kubectl apply -f deploy/
waitPodsReady
