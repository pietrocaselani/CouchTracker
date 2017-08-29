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

final class ListMoviesOutputTest: XCTestCase {

  let view = ListMoviesViewMock()
  let router = ListMoviesRouterMock()

  func testListMoviesOutput_receivesEmptyResults_shouldNotifyView() {
    let store = EmptyListMoviesStoreMock()
    let interactor = ListMoviesUseCase(repository: store)
    let presenter = ListMoviesPresenterMock(view: view, interactor: interactor, router: router)
    let output = ListMoviesSearchOutput(view: view, router: router, presenter: presenter)

    output.handleEmptySearchResult()

    XCTAssertTrue(view.invokedShowEmptyView)
  }

  func testListMoviesOutput_receivesCancel_shouldNotifyPresenter() {
    let store = EmptyListMoviesStoreMock()
    let interactor = ListMoviesUseCase(repository: store)
    let presenter = ListMoviesPresenterMock(view: view, interactor: interactor, router: router)
    let output = ListMoviesSearchOutput(view: view, router: router, presenter: presenter)

    output.searchCancelled()

    XCTAssertTrue(presenter.invokedFetchMovies)
  }

  func testListMoviesOutput_receivesError_shouldNotifyRouter() {
    let store = EmptyListMoviesStoreMock()
    let interactor = ListMoviesUseCase(repository: store)
    let presenter = ListMoviesPresenterMock(view: view, interactor: interactor, router: router)
    let output = ListMoviesSearchOutput(view: view, router: router, presenter: presenter)

    output.handleError(message: "There is no active connection")

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, "There is no active connection")
  }

  func testListMoviesOutput_receivesResults_shoudShowOnView() {
    let store = EmptyListMoviesStoreMock()
    let interactor = ListMoviesUseCase(repository: store)
    let presenter = ListMoviesPresenterMock(view: view, interactor: interactor, router: router)
    let output = ListMoviesSearchOutput(view: view, router: router, presenter: presenter)

    let searchResults = createSearchResultsMock()
    let viewModels = searchResults.map {
      SearchResultViewModel(type: $0.type, movie: MovieViewModel(title: $0.movie?.title ?? ""))
    }

    output.handleSearch(results: viewModels)

    let expectedParameters = viewModels.flatMap { $0.movie }

    XCTAssertTrue(view.invokedShow)
    XCTAssertEqual(view.invokedShowParameters!.movies, expectedParameters)
  }
}
