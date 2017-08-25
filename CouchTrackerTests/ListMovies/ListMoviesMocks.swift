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
  var invokedPresenterSetterCount = 0
  var invokedPresenter: ListMoviesPresenterLayer?
  var invokedPresenterList = [ListMoviesPresenterLayer!]()
  var invokedPresenterGetter = false
  var invokedPresenterGetterCount = 0
  var presenter: ListMoviesPresenterLayer!
  var invokedSearchViewSetter = false
  var invokedSearchViewSetterCount = 0
  var invokedSearchView: SearchView?
  var invokedSearchViewList = [SearchView!]()
  var invokedSearchViewGetter = false
  var invokedSearchViewGetterCount = 0
  var stubbedSearchView: SearchView!
  var searchView: SearchView!
  var invokedShowEmptyView = false
  var invokedShowEmptyViewCount = 0

  func showEmptyView() {
    invokedShowEmptyView = true
    invokedShowEmptyViewCount += 1
  }

  var invokedShow = false
  var invokedShowCount = 0
  var invokedShowParameters: (movies: [MovieViewModel], Void)?
  var invokedShowParametersList = [(movies: [MovieViewModel], Void)]()

  func show(movies: [MovieViewModel]) {
    invokedShow = true
    invokedShowCount += 1
    invokedShowParameters = (movies, ())
    invokedShowParametersList.append((movies, ()))
  }
}

final class ListMoviesPresenterMock: ListMoviesPresenterLayer {
  var invokedFetchMovies = false
  var invokedFetchMoviesCount = 0

  init(view: ListMoviesView, interactor: ListMoviesInteractorLayer, router: ListMoviesRouter) {}

  func fetchMovies() {
    invokedFetchMovies = true
    invokedFetchMoviesCount += 1
  }

  var invokedShowDetailsOfMovie = false
  var invokedShowDetailsOfMovieCount = 0
  var invokedShowDetailsOfMovieParameters: (index: Int, Void)?
  var invokedShowDetailsOfMovieParametersList = [(index: Int, Void)]()

  func showDetailsOfMovie(at index: Int) {
    invokedShowDetailsOfMovie = true
    invokedShowDetailsOfMovieCount += 1
    invokedShowDetailsOfMovieParameters = (index, ())
    invokedShowDetailsOfMovieParametersList.append((index, ()))
  }
}

final class ListMoviesRouterMock: ListMoviesRouter {
  var invokedShowDetails = false
  var invokedShowDetailsCount = 0
  var invokedShowDetailsParameters: (movie: TrendingMovie, Void)?
  var invokedShowDetailsParametersList = [(movie: TrendingMovie, Void)]()

  func showDetails(of movie: TrendingMovie) {
    invokedShowDetails = true
    invokedShowDetailsCount += 1
    invokedShowDetailsParameters = (movie, ())
    invokedShowDetailsParametersList.append((movie, ()))
  }

  var invokedShowError = false
  var invokedShowErrorCount = 0
  var invokedShowErrorParameters: (message: String, Void)?
  var invokedShowErrorParametersList = [(message: String, Void)]()

  func showError(message: String) {
    invokedShowError = true
    invokedShowErrorCount += 1
    invokedShowErrorParameters = (message, ())
    invokedShowErrorParametersList.append((message, ()))
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
