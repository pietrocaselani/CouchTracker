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

final class SearchViewMock: SearchView {
  var invokedPresenterSetter = false
  var invokedPresenterSetterCount = 0
  var invokedPresenter: SearchPresenterLayer?
  var invokedPresenterList = [SearchPresenterLayer!]()
  var invokedPresenterGetter = false
  var invokedPresenterGetterCount = 0
  var presenter: SearchPresenterLayer!
  var invokedHintSetter = false
  var invokedHintSetterCount = 0
  var invokedHint: String?
  var invokedHintList = [String?]()
  var invokedHintGetter = false
  var invokedHintGetterCount = 0
  var stubbedHint: String!
  var hint: String? {
    set {
      invokedHintSetter = true
      invokedHintSetterCount += 1
      invokedHint = newValue
      invokedHintList.append(newValue)
    }
    get {
      invokedHintGetter = true
      invokedHintGetterCount += 1
      return stubbedHint
    }
  }
}

final class SearchResultOutputMock: SearchResultOutput {
  var invokedHandleEmptySearchResult = false
  var invokedHandleEmptySearchResultCount = 0

  func handleEmptySearchResult() {
    invokedHandleEmptySearchResult = true
    invokedHandleEmptySearchResultCount += 1
  }

  var invokedHandleSearch = false
  var invokedHandleSearchCount = 0
  var invokedHandleSearchParameters: (results: [SearchResultViewModel], Void)?
  var invokedHandleSearchParametersList = [(results: [SearchResultViewModel], Void)]()

  func handleSearch(results: [SearchResultViewModel]) {
    invokedHandleSearch = true
    invokedHandleSearchCount += 1
    invokedHandleSearchParameters = (results, ())
    invokedHandleSearchParametersList.append((results, ()))
  }

  var invokedHandleError = false
  var invokedHandleErrorCount = 0
  var invokedHandleErrorParameters: (message: String, Void)?
  var invokedHandleErrorParametersList = [(message: String, Void)]()

  func handleError(message: String) {
    invokedHandleError = true
    invokedHandleErrorCount += 1
    invokedHandleErrorParameters = (message, ())
    invokedHandleErrorParametersList.append((message, ()))
  }

  var invokedSearchCancelled = false
  var invokedSearchCancelledCount = 0

  func searchCancelled() {
    invokedSearchCancelled = true
    invokedSearchCancelledCount += 1
  }
}

final class EmptySearchStoreMock: SearchStoreLayer {
  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    return Observable.empty()
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
  let data = Search.textQuery(types: [.movie], query: "Tron", page: 0, limit: 50).sampleData
  let options = JSONSerialization.ReadingOptions(rawValue: 0)

  let array = try! JSONSerialization.jsonObject(with: data, options: options) as! [[String: AnyObject]]

  return array.map { ObjectMapper.Map(mappingType: .fromJSON, JSON: $0) }.map { try! SearchResult(map: $0) }
}
