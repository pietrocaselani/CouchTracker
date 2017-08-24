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

class EmptyListMoviesStoreMock: ListMoviesStoreLayer {

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.empty()
  }
}

class ErrorListMoviesStoreMock: ListMoviesStoreLayer {

  private let error: ListMoviesError

  init(error: ListMoviesError) {
    self.error = error
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.error(error)
  }
}

class MoviesListMovieStoreMock: ListMoviesStoreLayer {

  private let movies: [TrendingMovie]

  init(movies: [TrendingMovie]) {
    self.movies = movies
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.just(movies).take(limit)
  }
}
