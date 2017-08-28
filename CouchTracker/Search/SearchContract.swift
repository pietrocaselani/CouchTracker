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

protocol SearchView: BaseView {
  var presenter: SearchPresenterLayer! { get set }

  func showHint(message: String)
}

protocol SearchResultOutput: class {
  func handleEmptySearchResult()
  func handleSearch(results: [SearchResultViewModel])
  func handleError(message: String)
  func searchCancelled()
}

protocol SearchPresenterLayer: class {

  init(view: SearchView, interactor: SearchInteractorLayer, resultOutput: SearchResultOutput)

  func viewDidLoad()
  func searchMovies(query: String)
  func cancelSearch()
}

protocol SearchInteractorLayer: class {

  init(store: SearchStoreLayer)

  func searchMovies(query: String) -> Observable<[SearchResult]>
}

protocol SearchStoreLayer: class {
  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]>
}
