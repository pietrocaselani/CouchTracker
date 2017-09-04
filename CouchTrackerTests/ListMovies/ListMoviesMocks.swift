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
import Trakt_Swift

final class ListMoviesViewMock: ListMoviesView {
  var presenter: ListMoviesPresenter!
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

final class ListMoviesPresenterMock: ListMoviesPresenter {
  var invokedFetchMovies = false

  init(view: ListMoviesView, interactor: ListMoviesInteractor, router: ListMoviesRouter) {}

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
  var invokedShowDetailsParameters: (movie: TrendingMovieEntity, Void)?

  func showDetails(of movie: TrendingMovieEntity) {
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

final class EmptyListMoviesStoreMock: ListMoviesRepository {
  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.empty()
  }
}

final class ErrorListMoviesStoreMock: ListMoviesRepository {

  private let error: Error

  init(error: Error) {
    self.error = error
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.error(error)
  }
}

final class MoviesListMovieStoreMock: ListMoviesRepository {

  private let movies: [TrendingMovie]

  init(movies: [TrendingMovie]) {
    self.movies = movies
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.just(movies).take(limit)
  }
}

final class ListMoviesServiceMock: ListMoviesInteractor {

  let listMoviesRepo: ListMoviesRepository
  let movieImageRepo: MovieImageRepository

  init(repository: ListMoviesRepository, movieImageRepository: MovieImageRepository) {
    self.listMoviesRepo = repository
    self.movieImageRepo = movieImageRepository
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovieEntity]> {
    let listMoviesObservable = listMoviesRepo.fetchMovies(page: page, limit: limit)
    let imagesObservable = movieImageRepo.fetchImages(for: 30)

    let observable = Observable.combineLatest(listMoviesObservable, imagesObservable) { (movies, images) -> [TrendingMovieEntity]  in
      let entities = movies.map { entity(for: $0, with: images) }
      return entities
    }

    return observable
  }

}
