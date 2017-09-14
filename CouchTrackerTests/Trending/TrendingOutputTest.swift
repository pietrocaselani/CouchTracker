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
  let searchView = SearchViewMock()
  var output: SearchResultOutput!
  var searchPresenter: SearchPresenter!

  override func setUp() {
    let dataSource = TrendingDataSourceMock()

    let repository = trendingRepositoryMock
    let interactor = TrendingServiceMock(repository: repository, imageRepository: imageRepositoryMock)
    output = TrendingiOSPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource)

    let searchRepository = SearchRepositoryAPIStubMock()
    let searchInteractor = SearchInteractorMock(repository: searchRepository)

    searchPresenter = SearchiOSPresenter(view: searchView, interactor: searchInteractor, resultOutput: output)

    super.setUp()
  }

  override func tearDown() {
    searchPresenter = nil

    print("Tear down")

    super.tearDown()
  }

  func testListMoviesOutput_receivesEmptyResults_shouldNotifyView() {
    searchPresenter.searchMovies(query: "No results")

    XCTAssertTrue(view.invokedShowEmptyView)
  }

  func testListMoviesOutput_receivesCancel_shouldNotifyView() {
    searchPresenter.cancelSearch()

    XCTAssertTrue(view.invokedShow)
  }

  func testListMoviesOutput_receivesError_shouldNotifyRouter() {
    let userInfo = [NSLocalizedDescriptionKey: "There is no active connection"]
    let searchError = NSError(domain: "com.arctouch", code: 0, userInfo: userInfo)
    let searchRepository = ErrorSearchStoreMock(error: searchError)
    let searchInteractor = SearchService(repository: searchRepository)
    searchPresenter = SearchiOSPresenter(view: searchView, interactor: searchInteractor, resultOutput: output)

    searchPresenter.searchMovies(query: "Cool movie")

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, "There is no active connection")
  }

  func testListMoviesOutput_receivesResults_shoudShowOnView() {
    searchPresenter.searchMovies(query: "TRON")

    XCTAssertTrue(view.invokedShow)
  }
}
