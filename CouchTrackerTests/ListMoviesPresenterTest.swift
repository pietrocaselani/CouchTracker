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

@testable import CouchTracker

final class ListMoviesPresenterTest: XCTestCase {

  let router = EmptyListMoviesRouterMock()
  let view = StateListMoviesViewMock()

  override func setUp() {
    super.setUp()
  }

  func testShowsEmptyView() {
    let interactor = ListMoviesInteractor(store: EmptyListMoviesStoreMock())

    let presenter = ListMoviesPresenter(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertEqual(view.currentState, StateListMoviesViewMock.State.showingNoMovies)
  }

  func testShowsErrorMessage() {
    let error = ListMoviesError.parseError("Invalid json")
    let interactor = ListMoviesInteractor(store: ErrorListMoviesStoreMock(error: error))

    let presenter = ListMoviesPresenter(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertEqual(view.currentState, StateListMoviesViewMock.State.showingError)
  }

  func testShowsMovies() {
    let movies = [
      MovieEntity(identifier: "Movie1", title: "Movie1"),
      MovieEntity(identifier: "Movie2", title: "Movie2")
    ]

    let store = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesInteractor(store: store)

    let presenter = ListMoviesPresenter(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    let moviesViewModel = [
      MovieViewModel(title: "Movie1"),
      MovieViewModel(title: "Movie2")
    ]

    XCTAssertEqual(view.currentState, StateListMoviesViewMock.State.showingMovies(moviesViewModel))
  }

  func testNoMovies() {
    let movies = [MovieEntity]()

    let store = MoviesListMovieStoreMock(movies: movies)
    let interactor = ListMoviesInteractor(store: store)

    let presenter = ListMoviesPresenter(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertEqual(view.currentState, StateListMoviesViewMock.State.showingNoMovies)
  }

}
