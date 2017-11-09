#!/bin/bash

if [ "$TRAVIS_BRANCH" = "master" ]; then
    echo "Running master.sh"
    ./ci/master.sh
else
    echo "Running pull_request.sh"
    ./ci/pull_request.sh
fi