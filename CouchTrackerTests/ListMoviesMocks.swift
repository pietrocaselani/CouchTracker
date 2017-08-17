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

class EmptyListMoviesStore: ListMoviesStore {

  func fetchMovies() -> Observable<[MovieEntity]> {
    return Observable.empty()
  }

}

class ErrorListMoviesStore: ListMoviesStore {

  private let error: MockError

  init(error: MockError) {
    self.error = error
  }

  func fetchMovies() -> Observable<[MovieEntity]> {
    return Observable.error(error)
  }

}

class MoviesListMovieStore: ListMoviesStore {

  private let movies: [MovieEntity]

  init(movies: [MovieEntity]) {
    self.movies = movies
  }

  func fetchMovies() -> Observable<[MovieEntity]> {
    return Observable.just(movies)
  }
}

enum MockError: Error {

  case noConnection(String)
  case parseError(String)

}
