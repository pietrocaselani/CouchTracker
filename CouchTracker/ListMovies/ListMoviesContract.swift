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

protocol ListMoviesPresenterOutput: class {

  init(view: ListMoviesView, interactor: ListMoviesInteractorInput)

  func viewDidLoad()
}

protocol ListMoviesView: BaseView {

  var presenter: ListMoviesPresenterOutput! { get set }

  func showEmptyView()
  func show(movies: [MovieViewModel])
  func show(error: String)
}

protocol ListMoviesInteractorInput: class {

  init(store: ListMoviesStoreInput)

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]>

}

protocol ListMoviesStoreInput: class {

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]>

}
