import RxSwift
import TraktSwift
import Moya

final class ShowProgressAPIRepository: ShowProgressRepository {
  private let trakt: TraktProvider

  init(trakt: TraktProvider) {
    self.trakt = trakt
  }

  func fetchShowProgress(ids: ShowIds, hideSpecials: Bool) -> Single<WatchedShowBuilder> {
    let builder = WatchedShowBuilder(ids: ids)

    let observable = fetchShowProgress(showId: ids.realId, hideSpecials)

    return observable.map {
      builder.progressShow = $0
      return builder
    }.flatMap { [unowned self] in self.fetchNextEpisodeDetails($0) }
  }

  private func fetchShowProgress(showId: String, _ hideSpecials: Bool) -> Single<BaseShow> {
    let target = Shows.watchedProgress(showId: showId,
                                       hidden: !hideSpecials,
                                       specials: !hideSpecials,
                                       countSpecials: !hideSpecials)
    return trakt.shows.rx.request(target).map(BaseShow.self)
  }

  private func fetchNextEpisodeDetails(_ builder: WatchedShowBuilder) -> Single<WatchedShowBuilder> {
    guard let episode = builder.progressShow?.nextEpisode else { return Single.just(builder) }

    let showId = builder.ids.realId

    let observable = fetchDetailsOf(episodeNumber: episode.number,
                                    on: episode.season, of: showId, extended: .full)

    return observable.map {
      builder.episode = $0
      return builder
      }.catchError { _ in return Single.just(builder) }
  }

  private func fetchDetailsOf(episodeNumber: Int, on seasonNumber: Int,
                              of showId: String, extended: Extended) -> Single<Episode> {
    let target = Episodes.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)
    return trakt.episodes.rx.request(target).map(Episode.self)
  }
}
