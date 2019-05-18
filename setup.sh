#!/usr/bin/env bash

brew bundle
sudo pip install lizard
bundle install --path vendor/bundle
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/tuist/install/master/install)"
