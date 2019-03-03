#!/bin/bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "Running pull_request.sh"
    ./ci/pull_request.sh
fi
