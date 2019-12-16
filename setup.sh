#!/usr/bin/env bash

brew bundle
bundle install --path vendor/bundle
bash <(curl -Ls https://install.tuist.io)
tuist install 0.19.0
