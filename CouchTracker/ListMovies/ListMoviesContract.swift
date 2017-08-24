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

protocol ListMoviesPresenterLayer: class {

  init(view: ListMoviesView, interactor: ListMoviesInteractorLayer)

  func viewDidLoad()
}

protocol ListMoviesView: BaseView {

  var presenter: ListMoviesPresenterLayer! { get set }

  func showEmptyView()
  func show(movies: [MovieViewModel])
  func show(error: String)
}

protocol ListMoviesInteractorLayer: class {

  init(store: ListMoviesStoreLayer)

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]>

}

protocol ListMoviesStoreLayer: class {

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]>

}
