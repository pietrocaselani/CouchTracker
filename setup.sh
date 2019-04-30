#!/usr/bin/env bash

function clone_dependency() {
    if [ ! -d "vendor/$1" ]; then
        echo "Cloning $1"
        git clone "https://github.com/pietrocaselani/${1}.git" "vendor/$1"
    fi
}

brew bundle
sudo pip install lizard
bundle install --path vendor/bundle

clone_dependency "Trakt-Swift"
clone_dependency "TMDB-Swift"
clone_dependency "TVDB-Swift"
