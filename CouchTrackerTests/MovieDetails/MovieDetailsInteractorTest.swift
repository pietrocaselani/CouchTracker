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
import TMDB_Swift

final class MovieDetailsInteractorTest: XCTestCase {

  private let scheduler: TestScheduler = TestScheduler(initialClock: 0)
  private var observer: TestableObserver<MovieEntity>!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver(MovieEntity.self)
  }

  override func tearDown() {
    observer = nil
    super.tearDown()
  }

  func testMovieDetailsInteractor_fetchSuccessWithEmptyData_andEmitsOnlyOnCompleted() {
    let movie = createMovieMock(for: "the-dark-knight-2008")
    let repository = MovieDetailsStoreMock(movie: createMovieDetailsMock())
    let genreRepository = GenreRepositoryMock()
    let imageRepository = movieImageRepositoryMock
    let interactor = MovieDetailsService(repository: repository, genreRepository: genreRepository,
                                         imageRepository: imageRepository, movieIds: movie.ids, scheduler: scheduler)

    let subscription = interactor.fetchDetails().subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<MovieEntity>>] = [completed(0)]

    XCTAssertEqual(observer.events, events)
  }

  func testMovieDetailsInteractor_fetchSuccessDetails_andEmitsDetailsAndOnCompleted() {
    let movie = createMovieDetailsMock()
    let repository = MovieDetailsStoreMock(movie: movie)
    let genreRepository = GenreRepositoryMock()
    let interactor = MovieDetailsService(repository: repository, genreRepository: genreRepository,
                                         imageRepository: movieImageRepositoryRealMock,
                                         movieIds: movie.ids, scheduler: scheduler)

    let subscription = interactor.fetchDetails().subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let genres = try! parseToJSONArray(data: Genres.list(.movies).sampleData).map { return try Genre(JSON: $0) }
    let moviesGenre = genres.filter { movie.genres?.contains($0.slug) ?? false }

    let images = try! Images(JSON: parseToJSONObject(data: Movies.images(movieId: movie.ids.tmdb ?? -1).sampleData))
    let imagesEntity = entity(for: images, using: configurationMock)

    let expectedMovie = MovieEntity(ids: movie.ids, title: movie.title, images: imagesEntity, genres: moviesGenre,
                tagline: movie.tagline, overview: movie.overview, releaseDate: movie.released)

    let events: [Recorded<Event<MovieEntity>>] = [next(0, expectedMovie), completed(0)]

    XCTAssertEqual(observer.events, events)
  }

  func testMoviesDetailsInteractor_fetchFailure_andEmitsOnlyOnError() {
    let connectionError = MovieDetailsError.noConnection("There is no connection active")
    let repository = ErrorMovieDetailsStoreMock(error: connectionError)
    let genreRepository = GenreRepositoryMock()
    let movieIds = createMovieDetailsMock().ids
    let interactor = MovieDetailsService(repository: repository, genreRepository: genreRepository,
                                         imageRepository: movieImageRepositoryMock,
                                         movieIds: movieIds, scheduler: scheduler)

    let subscription = interactor.fetchDetails().subscribe(observer)

    scheduler.scheduleAt(600) {
      subscription.dispose()
    }

    scheduler.start()

    let events: [Recorded<Event<MovieEntity>>] = [error(0, connectionError)]

    XCTAssertEqual(observer.events, events)

    XCTAssertEqual(observer.events[0].value.error as! MovieDetailsError, connectionError)
  }

}
