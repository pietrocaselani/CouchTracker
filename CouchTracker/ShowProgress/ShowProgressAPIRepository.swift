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

    return trakt.shows.rx.request(target).map(BaseShow.self).asObservable()
  }

  func fetchDetailsOf(update: Bool, episodeNumber: Int, on seasonNumber: Int,
                      of showId: String, extended: Extended) -> Observable<Episode> {
    let target = Episodes.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)

    return trakt.episodes.rx.request(target).map(Episode.self).asObservable()
  }
}
