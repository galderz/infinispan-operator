#!/usr/bin/env bash

set -e +x

function isPodReady() {
    [[ "$(kubectl get pod "$1" -n "$2" -o 'jsonpath={.status.conditions[?(@.type=="Ready")].status}')" == 'True' ]]
}

function showTruthy() {
    [[ ${1} == 0 ]] && echo "false" || echo "true"
}

function arePodsReady() {
    local pods=($(kubectl get pod -o 'jsonpath={.items[*].metadata.name}' --all-namespaces))
    local namespaces=($(kubectl get pod -o 'jsonpath={.items[*].metadata.namespace}' --all-namespaces))

    for ((i=0;i<${#pods[@]};++i)); do
        local isReady=$(isPodReady ${pods[i]} ${namespaces[i]})
        printf "Is pod %s/%s ready? %s\n" ${namespaces[i]} ${pods[i]} $(showTruthy ${isReady})
        ${isReady} || return 1
    done

    return 0
}

function waitPodsReady() {
    local limit=60
    local interval=1
    for ((i=0; i<${limit}; i+=${interval})); do
        if arePodsReady; then
            return 0
        fi

        echo "Waiting for pods to be ready..."
        sleep "$interval"
    done

    echo "Waited for ${limit} seconds, but all pods are not ready yet."
    return 1
}

waitPodsReady
