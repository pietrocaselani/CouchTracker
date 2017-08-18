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

@testable import CouchTracker

final class ListMoviesPresenterTest: XCTestCase {

  let router = EmptyListMoviesRouter()
  let view = StateListMoviesView()

  override func setUp() {
    super.setUp()
  }

  func testShowsEmptyView() {
    let interactor = ListMoviesInteractorImpl(store: EmptyListMoviesStore())

    let presenter = ListMoviesPresenterImpl(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertEqual(view.currentState, StateListMoviesView.State.showingNoMovies)
  }

  func testShowsErrorMessage() {
    let error = ListMoviesErrorMock.parseError("Invalid json")
    let interactor = ListMoviesInteractorImpl(store: ErrorListMoviesStore(error: error))

    let presenter = ListMoviesPresenterImpl(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertEqual(view.currentState, StateListMoviesView.State.showingError)
  }

  func testShowsMovies() {
    let movies = createMockMovies()

    let store = MoviesListMovieStore(movies: movies)
    let interactor = ListMoviesInteractorImpl(store: store)

    let presenter = ListMoviesPresenterImpl(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    let moviesViewModel = [
      MovieViewModel(title: "TRON: Legacy"),
      MovieViewModel(title: "The Dark Knight")
    ]

    XCTAssertEqual(view.currentState, StateListMoviesView.State.showingMovies(moviesViewModel))
  }

  func testNoMovies() {
    let movies = [TrendingMovie]()

    let store = MoviesListMovieStore(movies: movies)
    let interactor = ListMoviesInteractorImpl(store: store)

    let presenter = ListMoviesPresenterImpl(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertEqual(view.currentState, StateListMoviesView.State.showingNoMovies)
  }

  private func createMockMovies() -> [TrendingMovie] {
    let jsonData = Movies.trending(page: 0, limit: 50, extended: .full).sampleData
    return try! jsonData.mapArray(TrendingMovie.self)
  }

}
