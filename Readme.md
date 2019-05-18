CouchTracker
===

Keep track of your favorite movies and tv shows on your iPhone

[![CircleCI](https://circleci.com/gh/pietrocaselani/CouchTracker.svg?style=svg)](https://circleci.com/gh/pietrocaselani/CouchTracker)
[![codecov](https://codecov.io/gh/pietrocaselani/CouchTracker/branch/master/graph/badge.svg)](https://codecov.io/gh/pietrocaselani/CouchTracker)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=io.github.pietrocaselani.couchtracker&metric=alert_status)](https://sonarcloud.io/dashboard?id=io.github.pietrocaselani.couchtracker)
[![Twitter](https://img.shields.io/badge/twitter-@pietropc-red.svg?style=flat)](https://twitter.com/pietropc_)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fpietrocaselani%2FCouchTracker.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fpietrocaselani%2FCouchTracker?ref=badge_shield)
[![Tuist Badge](https://img.shields.io/badge/powered%20by-Tuist-green.svg?longCache=true)](https://github.com/tuist)

## Setup for development

Run the following commands

* `git clone git@github.com:pietrocaselani/CouchTracker.git`

* `cd CouchTracker && sh setup.sh`

* `tuist generate`

* `bundle exec pod install`

* `open CouchTracker.xcworkspace`

* This project uses the [Trakt API](https://trakt.docs.apiary.io/), [TMDB API](https://developers.themoviedb.org/3/getting-started) and [TVDB API](https://api.thetvdb.com/swagger)

* To run the app, please create a file at `CouchTrackerApp/Utils/Secrets.swift` with yours API keys like this

```swift
enum Secrets {
  enum Trakt {
    static let clientId = "API_KEY"
    static let clientSecret = "API_KEY"
    static let redirectURL = "API_KEY"
  }

  enum TMDB {
    static let apiKey = "API_KEY"
  }

  enum TVDB {
    static let apiKey = "API_KEY"
  }

  enum Bugsnag {
    static let apiKey = "API_KEY"
  }
}
```

## Project structure

The project is split into a few frameworks

* `CouchTrackerCore`: It's a macOS framework that has all the code that is not UI (Views, ViewControllers). This framework shouldn't have dependencies that only work on iOS.

* `CouchTrackerCore-iOS`: It's the iOS version of `CouchTrackerCore`. You won't find any files here, all files are on `CouchTrackerCore`.

* `CouchTrackerCoreTests`: The test bundle for `CouchTrackerCore`. Tests run directly on the macOS, there is no need to use the iOS simulator to run those tests.

* `CouchTrackerPersistence`: Here you will find entities and data sources and other things related to the persistence layer of the app. I moved this layer to another framework with the idea of changing the persistence tool in the future. Right now Realm is being used.

* `CouchTrackerApp`: Here you will find all the code related to UI and dependent on UIKit, so things like Views, ViewControllers. It's possible to import this framework into `CouchTrackerPlayground.playground` to see a preview of screens since the use of storyboards is being avoided.

* `CouchTracker`: It's the app itself. You will only find the `AppDelegate` here.


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fpietrocaselani%2FCouchTracker.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fpietrocaselani%2FCouchTracker?ref=badge_large)
