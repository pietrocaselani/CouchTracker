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

final class TrendingViewMock: TrendingView {
  var presenter: TrendingPresenter!
  var searchView: SearchView!
  var invokedShowEmptyView = false

  func showEmptyView() {
    invokedShowEmptyView = true
  }

  var invokedShow = false
  var invokedShowParameters: (movies: [TrendingViewModel], Void)?

  func show(trending: [TrendingViewModel]) {
    invokedShow = true
    invokedShowParameters = (trending, ())
  }
}

final class TrendingPresenterMock: TrendingPresenter {
  var invokedFetchTrending = false
  var invokedFetchTrendingParameters: (type: TrendingType, Void)?

  init(view: TrendingView, interactor: TrendingInteractor, router: TrendingRouter) {}

  func fetchTrending(of type: TrendingType) {
    invokedFetchTrending = true
    invokedFetchTrendingParameters = (type, ())
  }

  var invokedShowDetailsOfTrending = false
  var invokedShowDetailsOfTrendingParameters: (index: Int, Void)?

  func showDetailsOf(trending type: TrendingType, at index: Int) {
    invokedShowDetailsOfTrending = true
    invokedShowDetailsOfTrendingParameters = (index, ())
  }
}

final class TrendingRouterMock: TrendingRouter {
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

final class EmptyListMoviesStoreMock: TrendingRepository {
  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.empty()
  }

  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
    return Observable.empty()
  }
}

final class ErrorTrendingRepositoryMock: TrendingRepository {

  private let error: Error

  init(error: Error) {
    self.error = error
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.error(error)
  }

  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
    return Observable.empty()
  }
}

final class TrendingMoviesRepositoryMock: TrendingRepository {

  private let movies: [TrendingMovie]

  init(movies: [TrendingMovie]) {
    self.movies = movies
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return Observable.just(movies).take(limit)
  }

  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
    return Observable.empty()
  }
}

final class TrendingServiceMock: TrendingInteractor {

  let listMoviesRepo: TrendingRepository
  let movieImageRepo: ImageRepository

  init(repository: TrendingRepository, imageRepository: ImageRepository) {
    self.listMoviesRepo = repository
    self.movieImageRepo = imageRepository
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovieEntity]> {
    let moviesObservable = listMoviesRepo.fetchMovies(page: page, limit: limit)
    let imagesObservable = movieImageRepo.fetchImages(for: 30, posterSize: nil, backdropSize: nil)

    return Observable.combineLatest(moviesObservable, imagesObservable) { (movies, images) -> [TrendingMovieEntity] in
      return movies.map { entity(for: $0, with: images) }
    }
  }

  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShowEntity]> {
    return Observable.empty()
  }
}
