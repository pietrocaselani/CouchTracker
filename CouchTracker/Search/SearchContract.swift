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
import Trakt_Swift

protocol SearchView: BaseView {
  var presenter: SearchPresenter! { get set }

  func showHint(message: String)
}

protocol SearchResultOutput: class {
  func handleEmptySearchResult()
  func handleSearch(results: [SearchResult])
  func handleError(message: String)
  func searchCancelled()
}

protocol SearchPresenter: class {
  init(view: SearchView, interactor: SearchInteractor, resultOutput: SearchResultOutput)

  func viewDidLoad()
  func searchMovies(query: String)
  func cancelSearch()
}

protocol SearchInteractor: class {
  init(repository: SearchRepository)

  func searchMovies(query: String) -> Observable<[SearchResult]>
}

protocol SearchRepository: class {
  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]>
}
