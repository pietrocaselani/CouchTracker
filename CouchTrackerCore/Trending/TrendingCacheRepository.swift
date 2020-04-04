import Moya
import RxSwift
import TraktSwift

public final class TrendingCacheRepository: TrendingRepository {
  private let traktProvider: TraktProvider
  private let schedulers: Schedulers

  public init(traktProvider: TraktProvider, schedulers: Schedulers) {
    self.traktProvider = traktProvider
    self.schedulers = schedulers
  }

  public func fetchMovies(page: Int, limit: Int) -> Single<[TrendingMovie]> {
    traktProvider.movies.rx.request(.trending(page: page, limit: limit, extended: .full))
      .observeOn(schedulers.networkScheduler)
      .map([TrendingMovie].self)
  }

  public func fetchShows(page: Int, limit: Int) -> Single<[TrendingShow]> {
    traktProvider.shows.rx.request(.trending(page: page, limit: limit, extended: .full))
      .observeOn(schedulers.networkScheduler)
      .map([TrendingShow].self)
  }
}
