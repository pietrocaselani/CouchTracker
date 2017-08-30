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

import Moya
import ObjectMapper
import XCTest
import Trakt_Swift
import RxTest

final class ListMoviesPresenterTest: XCTestCase {

  private let scheduler = TestScheduler(initialClock: 0)
  let view = ListMoviesViewMock()
  let router = ListMoviesRouterMock()

  func testListMoviesPresenter_fetchSuccessWithEmptyData_andPresentNoMovies() {
    let interactor = ListMoviesServiceMock(repository: EmptyListMoviesStoreMock(), movieImageRepository: movieImageRepositoryMock)
    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()

    XCTAssertTrue(view.invokedShowEmptyView)
    XCTAssertFalse(view.invokedShow)
  }

  func testListMoviesPresenter_fetchFailure_andPresentError() {
    let error = ListMoviesError.parseError("Invalid json")
    let repository = ErrorListMoviesStoreMock(error: error)
    let interactor = ListMoviesServiceMock(repository: repository, movieImageRepository: movieImageRepositoryMock)
    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()

    XCTAssertTrue(self.router.invokedShowError)
    XCTAssertEqual(self.router.invokedShowErrorParameters?.message, "Invalid json")
  }

  func testListMoviesPresenter_fetchSuccess_andPresentMovies() {
    let movies = createMockMovies()
    let images = createImagesEntityMock()
    let repository = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesServiceMock(repository: repository, movieImageRepository: createMovieImagesRepositoryMock(images))
    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()

    let link = images.bestImage()?.link

    let expectedViewModel = movies.map { MovieViewModel(title: $0.movie.title ?? "TBA", imageLink: link) }

    XCTAssertTrue(view.invokedShow)
    XCTAssertEqual(view.invokedShowParameters!.movies, expectedViewModel)
  }

  func testListMoviesPresenter_fetchSuccess_andPresentNoMovies() {
    let movies = [TrendingMovie]()
    let images = createImagesEntityMock()
    let repository = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesServiceMock(repository: repository, movieImageRepository: createMovieImagesRepositoryMock(images))

    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()

    XCTAssertTrue(view.invokedShowEmptyView)
    XCTAssertFalse(view.invokedShow)
  }

  func testListMoviesPresenter_fetchFailure_andIsCustomError() {
    let userInfo = [NSLocalizedDescriptionKey: "Custom list movies error"]
    let error = NSError(domain: "com.arctouch.CouchTracker", code: 10, userInfo: userInfo)
    let interactor = ListMoviesServiceMock(repository: ErrorListMoviesStoreMock(error: error), movieImageRepository: movieImageRepositoryMock)

    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, "Custom list movies error")
  }

  func testListMoviesPresenter_requestToShowDetails_notifyRouterToShowDetails() {
    let movieIndex = 1
    let movies = createMockMovies()
    let images =  createImagesEntityMock()
    let repository = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesServiceMock(repository: repository, movieImageRepository: createMovieImagesRepositoryMock(images))
    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()
    presenter.showDetailsOfMovie(at: movieIndex)

    let expectedMovie = entity(for: movies[movieIndex], with: images)

    XCTAssertTrue(router.invokedShowDetails)
    XCTAssertEqual(router.invokedShowDetailsParameters?.movie, expectedMovie)
  }

  private func createMockMovies() -> [TrendingMovie] {
    let jsonData = Movies.trending(page: 0, limit: 50, extended: .full).sampleData
    return try! jsonData.mapArray(TrendingMovie.self)
  }

}
