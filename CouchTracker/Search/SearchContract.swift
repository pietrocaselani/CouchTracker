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
  var presenter: SearchPresenter! { get set }
}

protocol SearchResultOutput: class {
  func handleEmptySearchResult()
  func handleSearch(results: [SearchResultViewModel])
  func handleError(message: String)
}

protocol SearchPresenter: class {

  init(interactor: SearchInteractor, resultOutput: SearchResultOutput)

  func searchMovies(query: String)
}

protocol SearchInteractor: class {

  init(repository: SearchRepository)

  func searchMovies(query: String) -> Observable<[SearchResult]>
}

protocol SearchRepository: class {

  func search(query: String, types: [SearchType]) -> Observable<[SearchResult]>
}
