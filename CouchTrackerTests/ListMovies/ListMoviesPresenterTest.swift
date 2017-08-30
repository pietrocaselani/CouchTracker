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
import Trakt

final class ListMoviesPresenterTest: XCTestCase {

  let view = ListMoviesViewMock()
  let router = ListMoviesRouterMock()

  func testListMoviesPresenter_fetchSuccessWithEmptyData_andPresentNoMovies() {
    let interactor = ListMoviesUseCase(repository: EmptyListMoviesStoreMock())
    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()

    XCTAssertTrue(view.invokedShowEmptyView)
    XCTAssertFalse(view.invokedShow)
  }

  func testListMoviesPresenter_fetchFailure_andPresentError() {
    let error = ListMoviesError.parseError("Invalid json")
    let interactor = ListMoviesUseCase(repository: ErrorListMoviesStoreMock(error: error))
    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, "Invalid json")
  }

  func testListMoviesPresenter_fetchSuccess_andPresentMovies() {
    let movies = createMockMovies()
    let store = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesUseCase(repository: store)
    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()

    let expectedViewModel = movies.map { MovieViewModel(title: $0.movie.title ?? "TBA") }

    XCTAssertTrue(view.invokedShow)
    XCTAssertEqual(view.invokedShowParameters!.movies, expectedViewModel)
  }

  func testListMoviesPresenter_fetchSuccess_andPresentNoMovies() {
    let movies = [TrendingMovie]()
    let store = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesUseCase(repository: store)

    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()

    XCTAssertTrue(view.invokedShowEmptyView)
    XCTAssertFalse(view.invokedShow)
  }

  func testListMoviesPresenter_fetchFailure_andIsCustomError() {
    let userInfo = [NSLocalizedDescriptionKey: "Custom list movies error"]
    let error = NSError(domain: "com.arctouch.CouchTracker", code: 10, userInfo: userInfo)
    let interactor = ListMoviesUseCase(repository: ErrorListMoviesStoreMock(error: error))

    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, "Custom list movies error")
  }

  func testListMoviesPresenter_requestToShowDetails_notifyRouterToShowDetails() {
    let movieIndex = 1
    let movies = createMockMovies()
    let store = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesUseCase(repository: store)
    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchMovies()
    presenter.showDetailsOfMovie(at: movieIndex)

    XCTAssertTrue(router.invokedShowDetails)
    XCTAssertEqual(router.invokedShowDetailsParameters?.movie, movies[movieIndex])
  }

  private func createMockMovies() -> [TrendingMovie] {
    let jsonData = Movies.trending(page: 0, limit: 50, extended: .full).sampleData
    return try! jsonData.mapArray(TrendingMovie.self)
  }

}
