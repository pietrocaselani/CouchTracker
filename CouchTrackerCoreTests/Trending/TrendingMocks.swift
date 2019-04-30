@testable import CouchTrackerCore
import Foundation
import RxSwift
import TraktSwift

let trendingRepositoryMock = TrendingRepositoryMock(traktProvider: createTraktProviderMock())

final class TrendingViewMock: TrendingViewProtocol {
  var presenter: TrendingPresenter!

  var showEmptyViewInvokedCount = 0
  var showTrendingsViewInvokedCount = 0
  var showLoadingViewInvokedCount = 0

  func showEmptyView() {
    showEmptyViewInvokedCount += 1
  }

  func showTrendingsView() {
    showTrendingsViewInvokedCount += 1
  }

  func showLoadingView() {
    showLoadingViewInvokedCount += 1
  }
}

final class TrendingRouterMock: TrendingRouter {
  var invokedMovieDetails = false
  var invokedMovieDetailsParameters: (movie: MovieEntity, Void)?

  func showDetails(of movie: MovieEntity) {
    invokedMovieDetails = true
    invokedMovieDetailsParameters = (movie, ())
  }

  var invokedShowDetails = false
  var invokedShowDetailsParameters: (show: ShowEntity, Void)?

  func showDetails(of show: ShowEntity) {
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
  func fetchMovies(page _: Int, limit _: Int) -> Single<[TrendingMovie]> {
    return Single.just([TrendingMovie]())
  }

  func fetchShows(page _: Int, limit _: Int) -> Single<[TrendingShow]> {
    return Single.just([TrendingShow]())
  }
}

final class ErrorTrendingRepositoryMock: TrendingRepository {
  private let error: Error

  init(error: Error) {
    self.error = error
  }

  func fetchMovies(page _: Int, limit _: Int) -> Single<[TrendingMovie]> {
    return Single.error(error)
  }

  func fetchShows(page _: Int, limit _: Int) -> Single<[TrendingShow]> {
    return Single.error(error)
  }
}

final class TrendingMoviesRepositoryMock: TrendingRepository {
  private let movies: [TrendingMovie]

  init(movies: [TrendingMovie]) {
    self.movies = movies
  }

  func fetchMovies(page _: Int, limit: Int) -> Single<[TrendingMovie]> {
    return Single.just(movies)
  }

  func fetchShows(page _: Int, limit _: Int) -> Single<[TrendingShow]> {
    return Single.just([TrendingShow]())
  }
}

final class TrendingShowsRepositoryMock: TrendingRepository {
  private let shows: [TrendingShow]

  init(shows: [TrendingShow]) {
    self.shows = shows
  }

  func fetchMovies(page _: Int, limit _: Int) -> Single<[TrendingMovie]> {
    return Single.just([TrendingMovie]())
  }

  func fetchShows(page _: Int, limit: Int) -> Single<[TrendingShow]> {
    return Single.just(shows)
  }
}

final class TrendingRepositoryMock: TrendingRepository {
  private let traktProvider: TraktProvider

  init(traktProvider: TraktProvider) {
    self.traktProvider = traktProvider
  }

  func fetchMovies(page: Int, limit: Int) -> Single<[TrendingMovie]> {
    return traktProvider.movies.rx.request(.trending(page: page, limit: limit, extended: .full))
      .map([TrendingMovie].self)
  }

  func fetchShows(page: Int, limit: Int) -> Single<[TrendingShow]> {
    return traktProvider.shows.rx.request(.trending(page: page, limit: limit, extended: .full))
      .map([TrendingShow].self)
  }
}

final class TrendingServiceMock: TrendingInteractor {
  let trendingRepo: TrendingRepository

  init(repository: TrendingRepository) {
    trendingRepo = repository
  }

  func fetchMovies(page: Int, limit: Int) -> Single<[TrendingMovieEntity]> {
    let moviesObservable = trendingRepo.fetchMovies(page: page, limit: limit)

    return moviesObservable.map {
      $0.map {
        MovieEntityMapper.entity(for: $0, with: [Genre]())
      }
    }
  }

  func fetchShows(page: Int, limit: Int) -> Single<[TrendingShowEntity]> {
    return trendingRepo.fetchShows(page: page, limit: limit).map {
      $0.map {
        ShowEntityMapper.entity(for: $0, with: [Genre]())
      }
    }
  }
}

final class TrendingDataSourceMock: TrendingDataSource {
  var invokedSetViewModels = false

  var viewModels = [PosterViewModel]() {
    didSet {
      invokedSetViewModels = true
    }
  }
}
