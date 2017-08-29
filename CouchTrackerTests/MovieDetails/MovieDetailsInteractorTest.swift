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
import Trakt

final class MovieDetailsInteractorTest: XCTestCase {

  private let scheduler: TestScheduler = TestScheduler(initialClock: 0)
  private var observer: TestableObserver<Movie>!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver(Movie.self)
  }

  override func tearDown() {
    observer = nil
    super.tearDown()
  }

  func testMovieDetailsInteractor_fetchSuccessWithEmptyData_andEmitsOnlyOnCompleted() {
    let movie = createMovieDetailsMock()
    let store = MovieDetailsStoreMock(movie: movie)
    let interactor = MovieDetailsUseCase(repository: store, genreRepository: GenreStoreMock(), movieId: "the-dark-knight-2008")

    let subscription = interactor.fetchDetails().subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<Movie>>] = [completed(0)]

    XCTAssertEqual(observer.events, events)
  }

  func testMovieDetailsInteractor_fetchSuccessDetails_andEmitsDetailsAndOnCompleted() {
    let movie = createMovieDetailsMock()
    let store = MovieDetailsStoreMock(movie: movie)
    let interactor = MovieDetailsUseCase(repository: store, genreRepository: GenreStoreMock(), movieId: movie.ids.slug)

    let subscription = interactor.fetchDetails().subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<Movie>>] = [next(0, movie), completed(0)]

    XCTAssertEqual(observer.events, events)
  }

  func testMoviesDetailsInteractor_fetchFailure_andEmitsOnlyOnError() {
    let connectionError = MovieDetailsError.noConnection("There is no connection active")
    let store = ErrorMovieDetailsStoreMock(error: connectionError)
    let interactor = MovieDetailsUseCase(repository: store, genreRepository: GenreStoreMock(), movieId: "tron-legacy-2010")

    let subscription = interactor.fetchDetails().subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<Movie>>] = [error(0, connectionError)]

    XCTAssertEqual(observer.events, events)

    XCTAssertEqual(observer.events[0].value.error as! MovieDetailsError, connectionError)
  }

}
