import TraktSwift
import RxSwift
import Moya

final class ShowsProgressAPIRepository: ShowsProgressRepository {
  private let trakt: TraktProvider
  private let scheduler: SchedulerType
  private let cache: AnyCache<Int, NSData>

  convenience init(trakt: TraktProvider, cache: AnyCache<Int, NSData>) {
    let scheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "showsProgressQueue"))
    self.init(trakt: trakt, cache: cache, scheduler: scheduler)
  }

  init(trakt: TraktProvider, cache: AnyCache<Int, NSData>, scheduler: SchedulerType) {
    self.trakt = trakt
    self.cache = cache
    self.scheduler = scheduler
  }

  func fetchWatchedShows(update: Bool, extended: Extended) -> Observable<[BaseShow]> {
    let target = Sync.watched(type: .shows, extended: extended)

    let api = trakt.sync.rx.request(target).observeOn(scheduler)

    return api.map([BaseShow].self).asObservable()
  }
}
