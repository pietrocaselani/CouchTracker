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

import Foundation
import RxSwift

final class ListMoviesViewMock: ListMoviesView {
  var invokedPresenterSetter = false
  var presenter: ListMoviesPresenterLayer!
  var searchView: SearchView!
  var invokedShowEmptyView = false

  func showEmptyView() {
    invokedShowEmptyView = true
  }

  var invokedShow = false
  var invokedShowParameters: (movies: [MovieViewModel], Void)?

  func show(movies: [MovieViewModel]) {
    invokedShow = true
    invokedShowParameters = (movies, ())
  }
}

final class ListMoviesPresenterMock: ListMoviesPresenterLayer {
  var invokedFetchMovies = false

  init(view: ListMoviesView, interactor: ListMoviesInteractorLayer, router: ListMoviesRouter) {}

  func fetchMovies() {
    invokedFetchMovies = true
  }

  var invokedShowDetailsOfMovie = false
  var invokedShowDetailsOfMovieParameters: (index: Int, Void)?

  func showDetailsOfMovie(at index: Int) {
    invokedShowDetailsOfMovie = true
    invokedShowDetailsOfMovieParameters = (index, ())
  }
}

final class ListMoviesRouterMock: ListMoviesRouter {
  var invokedShowDetails = false
  var invokedShowDetailsParameters: (movie: TrendingMovie, Void)?

  func showDetails(of movie: TrendingMovie) {
    invokedShowDetails = true
    invokedShowDetailsParameters = (movie, ())
  }

  var invokedShowError = false
  var invokedShowErrorParameters: (message: String, Void)?

  func showError(message: String) {
    invokedShowError = true
    invokedShowErrorParameters = (message, ())
  }
}

final class EmptyListMoviesStoreMock: ListMoviesStoreLayer {
  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.empty()
  }
}

final class ErrorListMoviesStoreMock: ListMoviesStoreLayer {

  private let error: Error

  init(error: Error) {
    self.error = error
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.error(error)
  }
}

final class MoviesListMovieStoreMock: ListMoviesStoreLayer {

  private let movies: [TrendingMovie]

  init(movies: [TrendingMovie]) {
    self.movies = movies
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.just(movies).take(limit)
  }
}
