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

final class SearchPresenterTest: XCTestCase {
  let output = SearchResultOutputMock()

  func testSearchPresenter_performSearchSuccess_outputsTheResults() {
    let searchResultEntities = createSearchResultsMock()
    let store = SearchStoreMock(results: searchResultEntities)
    let interactor = SearchUseCase(repository: store)
    let presenter = SearchiOSPresenter(interactor: interactor, resultOutput: output)

    presenter.searchMovies(query: "Tron")

    let viewModels = searchResultEntities.map { result -> SearchResultViewModel in
      let movie = result.movie.map { viewModel(for: $0) }
      return SearchResultViewModel(type: result.type, movie: movie)
    }

    XCTAssertTrue(output.invokedHandleSearch)
    XCTAssertEqual(output.invokedHandleSearchParameters!.results, viewModels)
  }

  func testSearchPresenter_performSearchReceivesNoData_notifyOutput() {
    let store = SearchStoreMock(results: [SearchResult]())
    let interactor = SearchUseCase(repository: store)
    let presenter = SearchiOSPresenter(interactor: interactor, resultOutput: output)

    presenter.searchMovies(query: "Tron")

    XCTAssertTrue(output.invokedHandleEmptySearchResult)
  }

  func testSearchPresenter_performSearchFailure_outputsErrorMessage() {
    let userInfo = [NSLocalizedDescriptionKey: "There is no active connection"]
    let error = NSError(domain: "com.arctouch.CouchTracker", code: 10, userInfo: userInfo)
    let store = ErrorSearchStoreMock(error: error)
    let interactor = SearchUseCase(repository: store)
    let presenter = SearchiOSPresenter(interactor: interactor, resultOutput: output)

    presenter.searchMovies(query: "Tron")

    let expectedMessage = error.localizedDescription

    XCTAssertTrue(output.invokedHandleError)
    XCTAssertEqual(output.invokedHandleErrorParameters?.message, expectedMessage)
  }
}
