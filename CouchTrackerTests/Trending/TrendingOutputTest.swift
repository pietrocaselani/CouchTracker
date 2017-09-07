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

final class TrendingOutputTest: XCTestCase {

  let view = TrendingViewMock()
  let router = TrendingRouterMock()
  var presenter: TrendingPresenterMock!

  private func setupSearchOutputWithEmptyStore() -> SearchResultOutput {
    let repository = EmptyTrendingRepositoryMock()
    let interactor = TrendingService(repository: repository, imageRepository: movieImageRepositoryMock)
    presenter = TrendingPresenterMock(view: view, interactor: interactor, router: router)
    return TrendingSearchOutput(view: view, router: router, presenter: presenter)
  }

  func testListMoviesOutput_receivesEmptyResults_shouldNotifyView() {
    let output = setupSearchOutputWithEmptyStore()

    output.handleEmptySearchResult()

    XCTAssertTrue(view.invokedShowEmptyView)
  }

  func testListMoviesOutput_receivesCancel_shouldNotifyPresenter() {
    let output = setupSearchOutputWithEmptyStore()

    output.searchCancelled()

    XCTAssertTrue(presenter.invokedViewDidLoad)
  }

  func testListMoviesOutput_receivesError_shouldNotifyRouter() {
    let output = setupSearchOutputWithEmptyStore()

    output.handleError(message: "There is no active connection")

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, "There is no active connection")
  }

  func testListMoviesOutput_receivesResults_shoudShowOnView() {
    let output = setupSearchOutputWithEmptyStore()

    let searchResults = createSearchResultsMock()
    let viewModels = searchResults.map {
      SearchResultViewModel(type: $0.type, movie: TrendingViewModel(title: $0.movie?.title ?? "", imageLink: nil))
    }

    output.handleSearch(results: viewModels)

    let expectedParameters = viewModels.flatMap { $0.movie }

    XCTAssertTrue(view.invokedShow)
    XCTAssertEqual(view.invokedShowParameters!.viewModels, expectedParameters)
  }
}
