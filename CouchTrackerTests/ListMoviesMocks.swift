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

final class StateListMoviesViewMock: ListMoviesView {

  enum State: Equatable {
    case loaded
    case showingError
    case showingMovies([MovieViewModel])
    case showingNoMovies

    static func == (lhs: State, rhs: State) -> Bool {
      switch (lhs, rhs) {
      case (.loaded, .loaded):
        return true
      case (.showingNoMovies, .showingNoMovies):
        return true
      case let (.showingMovies(lhsMovies), .showingMovies(rhsMovies)):
        return lhsMovies == rhsMovies
      case (.showingError, .showingError):
        return true
      default: return false
      }
    }
  }

  var presenter: ListMoviesPresenterLayer!
  var currentState = State.loaded

  func showEmptyView() {
    currentState = .showingNoMovies
  }

  func show(error: String) {
    currentState = .showingError
  }

  func show(movies: [MovieViewModel]) {
    currentState = .showingMovies(movies)
  }
}

final class ListMoviesRouterMock: ListMoviesRouter {

  var invokedShowDetails = false
  var invokedShowDetailsCount = 0
  var invokedShowDetailsParameters: TrendingMovie?
  var invokedShowDetailsParametersList = [TrendingMovie]()

  func showDetails(of movie: TrendingMovie) {
    invokedShowDetails = true
    invokedShowDetailsCount += 1
    invokedShowDetailsParameters = movie
    invokedShowDetailsParametersList.append(movie)
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
