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

  func fetchWatchedShows(update: Bool, extended: Extended) -> Observable<WatchedShowEntity> {
    let target = Sync.watched(type: .shows, extended: extended)

    let api = trakt.sync.rx.request(target).observeOn(schedulers.networkScheduler)

    let observable = api.map([BaseShow].self).asObservable()

    let x = observable.flatMap { Observable.from($0) }
      .flatMap { [unowned self] in self.fetchShowProgress(update, $0) }
      .observeOn(schedulers.networkScheduler)

    return x
  }

  private func fetchShowProgress(_ update: Bool, _ baseShow: BaseShow) -> Observable<WatchedShowEntity> {
    guard let show = baseShow.show else { return Observable.empty() }

    return fetchShowProgress(update, ids: show.ids)
      .flatMap { [unowned self] in return self.mapToEntity(baseShow, builder: $0) }
      .observeOn(schedulers.networkScheduler)
  }

  private func fetchShowProgress(_ update: Bool, ids: ShowIds) -> Observable<WatchedShowBuilder> {
    let builder = WatchedShowBuilder(ids: ids)

    return buildProgressForShow(update, builder)
      .flatMap { [unowned self] in self.fetchNextEpisodeDetails($0) }
  }

  private func buildProgressForShow(_ update: Bool, _ builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    let showId = builder.ids.realId

    let observable = fetchShowProgress(showId: showId)

    return observable.map {
      builder.detailShow = $0
      return builder
    }
  }

  private func fetchShowProgress(showId: String) -> Observable<BaseShow> {
    let target = Shows.watchedProgress(showId: showId, hidden: true, specials: true, countSpecials: true)

    return trakt.shows.rx.request(target).observeOn(schedulers.networkScheduler).map(BaseShow.self).asObservable()
  }

  private func fetchNextEpisodeDetails(_ builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
    guard let episode = builder.detailShow?.nextEpisode else { return Observable.just(builder) }

    let showId = builder.ids.realId

    let observable = fetchDetailsOf(episodeNumber: episode.number,
                                               on: episode.season, of: showId, extended: .full)

    return observable.map {
      builder.episode = $0
      return builder
      }.catchErrorJustReturn(builder)
  }

  private func fetchDetailsOf(episodeNumber: Int, on seasonNumber: Int,
                              of showId: String, extended: Extended) -> Observable<Episode> {
    let target = Episodes.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)

    return trakt.episodes.rx.request(target).observeOn(schedulers.networkScheduler).map(Episode.self).asObservable()
  }

  private func mapToEntity(_ baseShow: BaseShow, builder: WatchedShowBuilder) -> Observable<WatchedShowEntity> {
    guard let show = baseShow.show else { return Observable.empty() }

    let showIds = builder.ids

    let showEntity = ShowEntityMapper.entity(for: show)
    let episodeEntity = builder.episode.map { EpisodeEntityMapper.entity(for: $0, showIds: showIds) }

    let aired = builder.detailShow?.aired ?? 0
    let completed = builder.detailShow?.completed ?? 0

    let lastWatched = builder.detailShow?.lastWatchedAt

    let entity = WatchedShowEntity(show: showEntity,
                                   aired: aired,
                                   completed: completed,
                                   nextEpisode: episodeEntity,
                                   lastWatched: lastWatched)
    return Observable.just(entity)
  }
}
