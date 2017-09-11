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

let trendingRepositoryMock = TrendingRepositoryMock(traktProvider: traktProviderMock)

func createTrendingShowsMock() -> [TrendingShow] {
  let jsonArray = JSONParser.toArray(data: Shows.trending(page: 0, limit: 10, extended: .full).sampleData)
  return try! jsonArray.map { try TrendingShow(JSON: $0) }
}

final class TrendingViewMock: TrendingView {
  var presenter: TrendingPresenter!
  var searchView: SearchView!
  var invokedShowEmptyView = false

  func showEmptyView() {
    invokedShowEmptyView = true
  }

  var invokedShow = false

  func showTrendingsView() {
    invokedShow = true
  }
}

final class TrendingPresenterMock: TrendingPresenter {
  let currentTrendingType = Variable<TrendingType>(.movies)
  var dataSource: TrendingDataSource
  var invokedViewDidLoad = false

  init(view: TrendingView, interactor: TrendingInteractor, router: TrendingRouter, dataSource: TrendingDataSource) {
    self.dataSource = dataSource
  }

  func viewDidLoad() {
    invokedViewDidLoad = true
  }

  var invokedShowDetailsOfTrending = false
  var invokedShowDetailsOfTrendingParameters: (index: Int, Void)?

  func showDetailsOfTrending(at index: Int) {
    invokedShowDetailsOfTrending = true
    invokedShowDetailsOfTrendingParameters = (index, ())
  }


}

final class TrendingRouterMock: TrendingRouter {
  var invokedMovieDetails = false
  var invokedMovieDetailsParameters: (movie: TrendingMovieEntity, Void)?

  func showDetails(of movie: TrendingMovieEntity) {
    invokedMovieDetails = true
    invokedMovieDetailsParameters = (movie, ())
  }

  var invokedShowDetails = false
  var invokedShowDetailsParameters: (show: TrendingShowEntity, Void)?

  func showDetails(of show: TrendingShowEntity) {
    invokedShowDetails = true
    invokedShowDetailsParameters = (show, ())
  }

  var invokedShowError = false
  var invokedShowErrorParameters: (message: String, Void)?

  func showError(message: String) {
    invokedShowError = true
    invokedShowErrorParameters = (message, ())
  }
}

final class EmptyTrendingRepositoryMock: TrendingRepository {
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
    return Observable.error(error)
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

final class TrendingRepositoryMock: TrendingRepository {
  private let traktProvider: TraktProvider

  init(traktProvider: TraktProvider) {
    self.traktProvider = traktProvider
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return traktProvider.movies.request(.trending(page: page, limit: limit, extended: .full))
      .mapArray(TrendingMovie.self)
  }

  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
    return traktProvider.shows.request(.trending(page: page, limit: limit, extended: .full))
      .mapArray(TrendingShow.self)
  }
}

final class TrendingServiceMock: TrendingInteractor {

  let trendingRepo: TrendingRepository
  let imageRepo: ImageRepository

  init(repository: TrendingRepository, imageRepository: ImageRepository) {
    self.trendingRepo = repository
    self.imageRepo = imageRepository
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovieEntity]> {
    let moviesObservable = trendingRepo.fetchMovies(page: page, limit: limit)

    return moviesObservable.map { $0.map { MovieEntityMapper.entity(for: $0) } }
  }

  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShowEntity]> {
    return trendingRepo.fetchShows(page: page, limit: limit).map {
      return $0.map { ShowEntityMapper.entity(for: $0) }
    }
  }
}

final class TrendingDataSourceMock: TrendingDataSource {
  var invokedSetViewModels = false

  var viewModels = [TrendingViewModel]() {
    didSet {
      invokedSetViewModels = true
    }
  }
}
