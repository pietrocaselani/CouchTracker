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

import RxSwift
import ObjectMapper
import Trakt

final class SearchViewMock: SearchView {
  var invokedPresenterSetter = false
  var presenter: SearchPresenterLayer!
  var invokedShowHint = false
  var invokedShowHintParameters: (message: String, Void)?

  func showHint(message: String) {
    invokedShowHint = true
    invokedShowHintParameters = (message, ())
  }
}

final class SearchResultOutputMock: SearchResultOutput {
  var invokedHandleEmptySearchResult = false

  func handleEmptySearchResult() {
    invokedHandleEmptySearchResult = true
  }

  var invokedHandleSearch = false
  var invokedHandleSearchParameters: (results: [SearchResultViewModel], Void)?

  func handleSearch(results: [SearchResultViewModel]) {
    invokedHandleSearch = true
    invokedHandleSearchParameters = (results, ())
  }

  var invokedHandleError = false
  var invokedHandleErrorParameters: (message: String, Void)?

  func handleError(message: String) {
    invokedHandleError = true
    invokedHandleErrorParameters = (message, ())
  }

  var invokedSearchCancelled = false

  func searchCancelled() {
    invokedSearchCancelled = true
  }
}

final class EmptySearchStoreMock: SearchStoreLayer {
  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    return Observable.just([SearchResult]())
  }
}

final class ErrorSearchStoreMock: SearchStoreLayer {
  private let error: Error

  init(error: Error) {
    self.error = error
  }

  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    return Observable.error(error)
  }
}

final class SearchStoreMock: SearchStoreLayer {
  private let results: [SearchResult]

  init(results: [SearchResult]) {
    self.results = results
  }

  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    return Observable.just(results).take(limit)
  }
}

func createSearchResultsMock() -> [SearchResult] {
  let data = Search.textQuery(types: [.movie], query: "Tron", page: 0, limit: 100).sampleData
  let options = JSONSerialization.ReadingOptions(rawValue: 0)

  let array = try! JSONSerialization.jsonObject(with: data, options: options) as! [[String: AnyObject]]

  return array.map { ObjectMapper.Map(mappingType: .fromJSON, JSON: $0) }.map { try! SearchResult(map: $0) }
}
