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
    let movies = [
      MovieEntity(identifier: "Movie1", title: "Movie1"),
      MovieEntity(identifier: "Movie2", title: "Movie2")
    ]

    let store = MoviesListMovieStore(movies: movies)
    let interactor = ListMoviesInteractorImpl(store: store)

    let presenter = ListMoviesPresenterImpl(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    let moviesViewModel = [
      MovieViewModel(title: "Movie1"),
      MovieViewModel(title: "Movie2")
    ]

    XCTAssertEqual(view.currentState, StateListMoviesView.State.showingMovies(moviesViewModel))
  }

  func testNoMovies() {
    let movies = [MovieEntity]()

    let store = MoviesListMovieStore(movies: movies)
    let interactor = ListMoviesInteractorImpl(store: store)

    let presenter = ListMoviesPresenterImpl(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertEqual(view.currentState, StateListMoviesView.State.showingNoMovies)
  }

}
