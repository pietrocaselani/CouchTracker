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

@testable import CouchTracker_Ugly

final class ListMoviesPresenterTest: XCTestCase {

  let view = StateListMoviesViewMock()

  override func setUp() {
    super.setUp()
  }

  func testShowsEmptyView() {
    let interactor = ListMoviesInteractor(store: EmptyListMoviesStoreMock())

    let presenter = ListMoviesPresenter(view: view, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertEqual(view.currentState, StateListMoviesViewMock.State.showingNoMovies)
  }

  func testShowsErrorMessage() {
    let error = ListMoviesError.parseError("Invalid json")
    let interactor = ListMoviesInteractor(store: ErrorListMoviesStoreMock(error: error))

    let presenter = ListMoviesPresenter(view: view, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertEqual(view.currentState, StateListMoviesViewMock.State.showingError)
  }

  func testShowsMovies() {
    let movies = createMockMovies()

    let store = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesInteractor(store: store)

    let presenter = ListMoviesPresenter(view: view, interactor: interactor)

    presenter.viewDidLoad()

    let moviesViewModel = [
      MovieViewModel(title: "TRON: Legacy"),
      MovieViewModel(title: "The Dark Knight")
    ]

    XCTAssertEqual(view.currentState, StateListMoviesViewMock.State.showingMovies(moviesViewModel))
  }

  func testNoMovies() {
    let movies = [TrendingMovie]()

    let store = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesInteractor(store: store)

    let presenter = ListMoviesPresenter(view: view, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertEqual(view.currentState, StateListMoviesViewMock.State.showingNoMovies)
  }

  private func createMockMovies() -> [TrendingMovie] {
    let jsonData = Movies.trending(page: 0, limit: 50, extended: .full).sampleData
    return try! jsonData.mapArray(TrendingMovie.self)
  }

}
