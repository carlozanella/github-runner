#!/bin/bash

cd /home/docker/actions-runner

./config.sh --url ${URL} --token ${TOKEN} --unattended --replace --disableupdate

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${TOKEN} --replace --disableupdate
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
