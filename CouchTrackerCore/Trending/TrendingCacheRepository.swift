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

  public func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return traktProvider.movies.rx.request(.trending(page: page, limit: limit, extended: .full))
      .asObservable()
      .observeOn(schedulers.networkScheduler)
      .map([TrendingMovie].self)
  }

  public func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
    return traktProvider.shows.rx.request(.trending(page: page, limit: limit, extended: .full))
      .asObservable()
      .observeOn(schedulers.networkScheduler)
      .map([TrendingShow].self)
  }
}
