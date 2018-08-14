CouchTracker
===

Keep track of your favorite movies and tv shows on your iPhone

[![Build Status](https://travis-ci.org/pietrocaselani/CouchTracker.svg?branch=master)](https://travis-ci.org/pietrocaselani/CouchTracker)
[![codecov](https://codecov.io/gh/pietrocaselani/CouchTracker/branch/master/graph/badge.svg)](https://codecov.io/gh/pietrocaselani/CouchTracker)
[![Twitter](https://img.shields.io/badge/twitter-@pietropc-red.svg?style=flat)](https://twitter.com/pietropc_)

## Instructions

Run the following commands

* `cd CouchTracker && sh setup.sh && bundle exec pod install`

* `Open CouchTracker.xcworkspace`

* This project uses the [Trakt API](https://trakt.docs.apiary.io/), [TMDB API](https://developers.themoviedb.org/3/getting-started) and [TVDB API](https://api.thetvdb.com/swagger)

* To run the app, please create a file at `CouchTracker/Utils/Secrets.swift` with yours API keys like this

```swift
final class Secrets {
  private init() {}

  final class Trakt {
    private init() {}
    static let clientId = ""
    static let clientSecret = ""
    static let redirectURL = ""
  }

  final class TMDB {
    private init() {}
    static let apiKey = ""
  }

  final class TVDB {
    private init() {}
    static let apiKey = ""
  }
}
```

## Tests

Run the tests on `CouchTrackerCore` target.
