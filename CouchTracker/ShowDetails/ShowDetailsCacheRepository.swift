import RxSwift
import Moya
import TraktSwift

final class ShowDetailsCacheRepository: ShowDetailsRepository {
  private let traktProvider: TraktProvider
  private let schedulers: Schedulers

  init(traktProvider: TraktProvider, schedulers: Schedulers) {
    self.traktProvider = traktProvider
    self.schedulers = schedulers
  }

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
    return traktProvider.shows.rx.request(.summary(showId: identifier, extended: extended))
      .observeOn(schedulers.networkScheduler)
      .map(Show.self)
  }
}
