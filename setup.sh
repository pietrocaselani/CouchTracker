#!/bin/bash

function clone_dependency() {
    echo "Cloning $1"
    git clone git@github.com:pietrocaselani/$1.git vendor/$1
}

brew install sonar-scanner
brew install tailor
brew install swiftformat
sudo pip install lizard
bundle install --path vendor/bundle
clone_dependency "Trakt-Swift"
clone_dependency "TMDB-Swift"
clone_dependency "TVDB-Swift"
