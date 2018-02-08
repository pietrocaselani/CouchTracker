import TraktSwift
import RxSwift

final class ShowEpisodeAPIRepository: ShowEpisodeRepository {
  private let trakt: TraktProvider
  private let schedulers: Schedulers
  private let dataSource: ShowEpisodeDataSource

  init(trakt: TraktProvider, dataSource: ShowEpisodeDataSource, schedulers: Schedulers) {
    self.trakt = trakt
    self.schedulers = schedulers
    self.dataSource = dataSource
  }

  func addToHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult> {
    let watchedAt = Date()
    let items = toSyncItems(episode, watchedAt)

    return performSyncRequest(.addToHistory(items: items))
      .flatMap { [unowned self] syncResponse -> Single<WatchedShowEntity> in
        return self.fetchShowProgress(ids: show.show.ids).map { $0.createEntity(using: show.show) }
      }.observeOn(schedulers.dataSourceScheduler)
      .do(onSuccess: { [unowned self] newWatchedShowEntity in
        try self.dataSource.updateWatched(show: newWatchedShowEntity)
      }).map { newWatchedShowEntity -> SyncResult in
        SyncResult.success(show: newWatchedShowEntity)
      }.catchError { error -> Single<SyncResult> in
        Single.just(SyncResult.fail(error: error))
      }
  }

  func removeFromHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult> {
    let watchedAt = Date()
    let items = toSyncItems(episode, watchedAt)

    return performSyncRequest(.removeFromHistory(items: items))
      .flatMap { [unowned self] syncResponse -> Single<WatchedShowEntity> in
        return self.fetchShowProgress(ids: show.show.ids).map { $0.createEntity(using: show.show) }
      }.observeOn(schedulers.dataSourceScheduler)
      .do(onSuccess: { [unowned self] newWatchedShowEntity in
        try self.dataSource.updateWatched(show: newWatchedShowEntity)
      }).map { newWatchedShowEntity -> SyncResult in
        SyncResult.success(show: newWatchedShowEntity)
      }.catchError { error -> Single<SyncResult> in
        Single.just(SyncResult.fail(error: error))
    }
  }

  private func performSyncRequest(_ target: Sync) -> Single<SyncResponse> {
    return trakt.sync.rx.request(target)
      .observeOn(schedulers.networkScheduler)
      .filterSuccessfulStatusAndRedirectCodes()
      .map(SyncResponse.self)
  }

  private func toSyncItems(_ episode: EpisodeEntity, _ watchedAt: Date) -> SyncItems {
    let syncEpisode = SyncEpisode(ids: episode.ids, watchedAt: watchedAt)
    return SyncItems(episodes: [syncEpisode])
  }

  private func fetchShowProgress(ids: ShowIds) -> Single<WatchedShowBuilder> {
    let builder = WatchedShowBuilder(ids: ids)

    return buildProgressForShow(builder)
      .flatMap { [unowned self] in self.fetchNextEpisodeDetails($0) }
  }

  private func buildProgressForShow(_ builder: WatchedShowBuilder) -> Single<WatchedShowBuilder> {
    let showId = builder.ids.realId

    let observable = fetchShowProgress(showId: showId)

    return observable.map {
      builder.detailShow = $0
      return builder
    }
  }

  private func fetchShowProgress(showId: String) -> Single<BaseShow> {
    let target = Shows.watchedProgress(showId: showId, hidden: true, specials: true, countSpecials: true)

    return trakt.shows.rx.request(target).map(BaseShow.self).observeOn(schedulers.networkScheduler)
  }

  private func fetchNextEpisodeDetails(_ builder: WatchedShowBuilder) -> Single<WatchedShowBuilder> {
    guard let episode = builder.detailShow?.nextEpisode else { return Single.just(builder) }

    let showId = builder.ids.realId

    let observable = fetchDetailsOf(episodeNumber: episode.number,
                                    on: episode.season, of: showId, extended: .full)

    return observable.map {
      builder.episode = $0
      return builder
      }.catchError { error -> Single<WatchedShowBuilder> in
        return Single.just(builder)
      }
  }

  private func fetchDetailsOf(episodeNumber: Int, on seasonNumber: Int,
                              of showId: String, extended: Extended) -> Single<Episode> {
    let target = Episodes.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)

    return trakt.episodes.rx.request(target).map(Episode.self).observeOn(schedulers.networkScheduler)
  }

  private func mapToEntity(_ baseShow: BaseShow, builder: WatchedShowBuilder) -> Single<WatchedShowEntity> {
    guard let show = baseShow.show else { Swift.fatalError("Can't create WatchedShowEntity without show") }

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

    return Single.just(entity).observeOn(schedulers.networkScheduler)
  }
}
