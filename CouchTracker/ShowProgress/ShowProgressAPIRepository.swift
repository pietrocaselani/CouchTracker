import RxSwift
import TraktSwift

final class ShowProgressAPIRepository: ShowProgressRepository {
  private let trakt: TraktProvider
  private let schedulers: Schedulers

  init(trakt: TraktProvider, schedulers: Schedulers) {
    self.trakt = trakt
    self.schedulers = schedulers
  }

  func fetchShowProgress(showId: String, hidden: Bool,
                         specials: Bool, countSpecials: Bool) -> Observable<BaseShow> {
    let target = Shows.watchedProgress(showId: showId, hidden: hidden, specials: specials, countSpecials: countSpecials)

    return trakt.shows.rx.request(target).observeOn(schedulers.networkScheduler).map(BaseShow.self).asObservable()
  }

  func fetchDetailsOf(episodeNumber: Int, on seasonNumber: Int,
                      of showId: String, extended: Extended) -> Observable<Episode> {
    let target = Episodes.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)

    return trakt.episodes.rx.request(target).observeOn(schedulers.networkScheduler).map(Episode.self).asObservable()
  }
}
