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
import Trakt

protocol ListMoviesRouter: class {
  func showDetails(of movie: TrendingMovie)
  func showError(message: String)
}

protocol ListMoviesPresenter: class {

  init(view: ListMoviesView, interactor: ListMoviesInteractor, router: ListMoviesRouter)

  func fetchMovies()
  func showDetailsOfMovie(at index: Int)
}

protocol ListMoviesView: BaseView {

  var presenter: ListMoviesPresenter! { get set }
  var searchView: SearchView! { get set }

  func showEmptyView()
  func show(movies: [MovieViewModel])
}

protocol ListMoviesInteractor: class {

  init(repository: ListMoviesRepository)

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]>
}

protocol ListMoviesRepository: class {

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]>
}
