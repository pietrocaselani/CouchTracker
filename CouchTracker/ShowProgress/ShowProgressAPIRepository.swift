import RxSwift
import TraktSwift

final class ShowProgressAPIRepository: ShowProgressRepository {
  private let trakt: TraktProvider
  private let scheduler: SchedulerType
  private let cache: AnyCache<Int, NSData>

  convenience init(trakt: TraktProvider, cache: AnyCache<Int, NSData>) {
    let scheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "showsProgressAPIRepositoryQueue"))
    self.init(trakt: trakt, cache: cache, scheduler: scheduler)
  }

  init(trakt: TraktProvider, cache: AnyCache<Int, NSData>, scheduler: SchedulerType) {
    self.trakt = trakt
    self.cache = cache
    self.scheduler = scheduler
  }

  func fetchShowProgress(update: Bool, showId: String, hidden: Bool,
                         specials: Bool, countSpecials: Bool) -> Observable<BaseShow> {
    let target = Shows.watchedProgress(showId: showId, hidden: hidden, specials: specials, countSpecials: countSpecials)
    let cacheKey = target.hashValue

    let api = trakt.shows.requestDataSafety(target).observeOn(scheduler)

    guard update else {
      return fetchFromCacheFirst(api: api, cacheKey: cacheKey).mapObject(BaseShow.self)
    }

    return api.mapObject(BaseShow.self)
  }

  func fetchDetailsOf(update: Bool, episodeNumber: Int, on seasonNumber: Int,
                      of showId: String, extended: Extended) -> Observable<Episode> {
    let target = Episodes.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)
    let cacheKey = target.hashValue

    let api = trakt.episodes.requestDataSafety(target).observeOn(scheduler).cache(cache, key: cacheKey)

    guard update else {
      return fetchFromCacheFirst(api: api, cacheKey: cacheKey).mapObject(Episode.self)
    }

    return api.mapObject(Episode.self)
  }

  private func fetchFromCacheFirst(api: Observable<NSData>, cacheKey: Int) -> Observable<NSData> {
    return cache.get(cacheKey).observeOn(scheduler)
      .ifEmpty(switchTo: api)
      .catchError { _ in api }
      .subscribeOn(scheduler)
  }
}
