CouchTracker
===

Keep track of your favorite movies and tv shows on your iPhone

[![Build Status](https://travis-ci.org/pietrocaselani/CouchTracker.svg?branch=master)](https://travis-ci.org/pietrocaselani/CouchTracker)
[![codecov](https://codecov.io/gh/pietrocaselani/CouchTracker/branch/master/graph/badge.svg)](https://codecov.io/gh/pietrocaselani/CouchTracker)
[![Twitter](https://img.shields.io/badge/twitter-@pietropc-red.svg?style=flat)](https://twitter.com/pietropc_)

## Setup for development

Run the following commands

* `git clone git@github.com:pietrocaselani/CouchTracker.git`

* `cd CouchTracker && sh setup.sh && bundle exec pod install`

* `open CouchTracker.xcworkspace`

* This project uses the [Trakt API](https://trakt.docs.apiary.io/), [TMDB API](https://developers.themoviedb.org/3/getting-started) and [TVDB API](https://api.thetvdb.com/swagger)

* To run the app, please create a file at `CouchTracker/Utils/Secrets.swift` with yours API keys like this

```swift
enum Secrets {
  enum Trakt {
    static let clientId = ""
    static let clientSecret = ""
    static let redirectURL = ""
  }

  enum TMDB {
    static let apiKey = ""
  }

  enum TVDB {
    static let apiKey = ""
  }
}
```

## Running tests

Run the tests on `CouchTrackerCore` target.

Hey
