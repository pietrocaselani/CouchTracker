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
    let cacheKey = target.hashValue

    let api = trakt.sync.requestDataSafety(target).observeOn(scheduler).cache(cache, key: cacheKey)

    guard update else {
      return fetchFromCacheFirst(api: api, cacheKey: cacheKey).mapArray(BaseShow.self)
    }

    return api.mapArray(BaseShow.self)
  }

  private func fetchFromCacheFirst(api: Observable<NSData>, cacheKey: Int) -> Observable<NSData> {
    return cache.get(cacheKey)
      .observeOn(scheduler)
      .ifEmpty(switchTo: api)
      .catchError { _ in api }
      .subscribeOn(scheduler)
  }
}
