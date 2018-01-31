import TraktSwift
import RxSwift
import Moya

final class ShowsProgressAPIRepository: ShowsProgressRepository {
  private let trakt: TraktProvider
  private let schedulers: Schedulers

  init(trakt: TraktProvider,
       schedulers: Schedulers) {
    self.trakt = trakt
    self.schedulers = schedulers
  }

  func fetchWatchedShows(update: Bool, extended: Extended) -> Observable<[BaseShow]> {
    let target = Sync.watched(type: .shows, extended: extended)

    let api = trakt.sync.rx.request(target).observeOn(schedulers.networkScheduler)

    return api.map([BaseShow].self).asObservable()
  }
}
