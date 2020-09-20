#!/usr/bin/env bash
set -e

SCRIPT_DIR=$(echo "${BASH_SOURCE[0]}" | xargs dirname | xargs -I % sh -c 'cd % && pwd')

cd "$SCRIPT_DIR" || exit 1

tuist generate
bundle exec pod install
