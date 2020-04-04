#!/usr/bin/env bash
set -e

carthage update --platform iOS --cache-builds
tuist generate
bundle exec pod install
