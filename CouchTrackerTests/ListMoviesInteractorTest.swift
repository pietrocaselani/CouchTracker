/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.
 
 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

import XCTest
import RxSwift
import RxTest
@testable import CouchTracker

final class ListMoviesInteractorTest: XCTestCase {

  private let scheduler = TestScheduler(initialClock: 0)
  private var observer: TestableObserver<[MovieEntity]>!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver([MovieEntity].self)
  }

  func testHandleEmpty() {
    let store = EmptyListMoviesStoreMock()
    let interactor = ListMoviesInteractor(store: store)

    let subscription = interactor.fetchMovies().subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<[MovieEntity]>>] = [completed(0)]

    RXAssertEvents(observer, events)
  }

  func testHandleError() {
    let connectionError = ListMoviesError.noConnection("There is no connection active")

    let store = ErrorListMoviesStoreMock(error: connectionError)
    let interactor = ListMoviesInteractor(store: store)

    let subscription = interactor.fetchMovies().subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<[MovieEntity]>>] = [error(0, connectionError)]

    RXAssertEvents(observer, events)
  }

  func testHandleMovies() {
    let movies = [
      MovieEntity(identifier: "Movie1", title: "Movie1"),
      MovieEntity(identifier: "Movie2", title: "Movie2")
    ]

    let store = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesInteractor(store: store)

    let subscription = interactor.fetchMovies().subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<[MovieEntity]>>] = [next(0, movies), completed(0)]

    RXAssertEvents(observer, events)
  }

}
