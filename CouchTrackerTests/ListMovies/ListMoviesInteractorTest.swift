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
import Trakt_Swift

final class ListMoviesInteractorTest: XCTestCase {

  private let scheduler = TestScheduler(initialClock: 0)
  private var observer: TestableObserver<[TrendingMovieEntity]>!

  private var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver([TrendingMovieEntity].self)
    disposeBag = DisposeBag()
  }

  override func tearDown() {
    observer = nil
    disposeBag = nil
    super.tearDown()
  }

  func testHandleEmpty() {
    let repository = EmptyListMoviesStoreMock()
    let imageRepository = EmptyMovieImageRepositoryMock(tmdbProvider: tmdbProviderMock,
                                                        cofigurationRepository: configurationRepositoryMock)
    let interactor = ListMoviesService(repository: repository, movieImageRepository: imageRepository, scheduler: scheduler)

    let subscription = interactor.fetchMovies(page: 0, limit: 10).subscribe(observer)
    subscription.disposed(by: disposeBag)

    scheduler.start()

    let events: [Recorded<Event<[TrendingMovieEntity]>>] = [completed(0)]

    RXAssertEvents(observer, events)
  }

  func testHandleError() {
    let connectionError = ListMoviesError.noConnection("There is no connection active")

    let repository = ErrorListMoviesStoreMock(error: connectionError)
    let interactor = ListMoviesService(repository: repository, movieImageRepository: movieImageRepositoryMock, scheduler: scheduler)

    let subscription = interactor.fetchMovies(page: 0, limit: 10).subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<[TrendingMovieEntity]>>] = [error(0, connectionError)]

    RXAssertEvents(observer, events)
  }

  func testHandleMovies() {
    let movies = [TrendingMovie]()

    let repository = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesService(repository: repository, movieImageRepository: movieImageRepositoryMock, scheduler: scheduler)

    let subscription = interactor.fetchMovies(page: 0, limit: 10).subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<[TrendingMovieEntity]>>] = [completed(0)]

    RXAssertEvents(observer, events)
  }
}
