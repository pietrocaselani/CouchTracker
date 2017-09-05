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

final class TrendingInteractorTest: XCTestCase {

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
    let imageRepository = EmptyImageRepositoryMock(tmdbProvider: tmdbProviderMock,
                                                        cofigurationRepository: configurationRepositoryMock)
    let interactor = TrendingService(repository: repository, imageRepository: imageRepository, scheduler: scheduler)

    let subscription = interactor.fetchMovies(page: 0, limit: 10).subscribe(observer)
    subscription.disposed(by: disposeBag)

    scheduler.start()

    let events: [Recorded<Event<[TrendingMovieEntity]>>] = [completed(0)]

    RXAssertEvents(observer, events)
  }

  func testHandleError() {
    let connectionError = TrendingError.noConnection("There is no connection active")

    let repository = ErrorTrendingRepositoryMock(error: connectionError)
    let interactor = TrendingService(repository: repository, imageRepository: movieImageRepositoryMock, scheduler: scheduler)

    let subscription = interactor.fetchMovies(page: 0, limit: 10).subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<[TrendingMovieEntity]>>] = [error(0, connectionError)]

    RXAssertEvents(observer, events)
  }

  func testHandleMovies() {
    let movies = createMockMovies()

    let repository = TrendingMoviesRepositoryMock(movies: movies)
    let interactor = TrendingService(repository: repository, imageRepository: movieImageRepositoryRealMock, scheduler: scheduler)

    let subscription = interactor.fetchMovies(page: 0, limit: 10).subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let expectedMovies = movies.map { trendingMovie -> TrendingMovieEntity in
      let images = createImagesMock(movieId: trendingMovie.movie.ids.tmdb ?? -1)
      return entity(for: trendingMovie, with: entity(for: images, using: configurationMock))
    }

    let events: [Recorded<Event<[TrendingMovieEntity]>>] = [next(0, expectedMovies), completed(0)]

    RXAssertEvents(observer, events)
  }
}
