import TraktSwift
import RxSwift

final class ShowEpisodeAPIRepository: ShowEpisodeRepository {
  private let trakt: TraktProvider
  private let schedulers: Schedulers
  private let dataSource: ShowEpisodeDataSource
  private let showProgressRepository: ShowProgressRepository

  init(trakt: TraktProvider, dataSource: ShowEpisodeDataSource,
       schedulers: Schedulers, showProgressRepository: ShowProgressRepository) {
    self.trakt = trakt
    self.schedulers = schedulers
    self.dataSource = dataSource
    self.showProgressRepository = showProgressRepository
  }

  func addToHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult> {
    let syncEpisode = SyncEpisode(ids: episode.ids)
    let items = SyncItems(episodes: [syncEpisode])

    return performSyncRequest(.addToHistory(items: items), show.show)
  }

  func removeFromHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult> {
    let syncEpisode = SyncEpisode(ids: episode.ids)
    let items = SyncItems(episodes: [syncEpisode])

    return performSyncRequest(.removeFromHistory(items: items), show.show)
  }

  private func performSyncRequest(_ target: Sync, _ show: ShowEntity) -> Single<SyncResult> {
    return trakt.sync.rx.request(target)
      .observeOn(schedulers.networkScheduler)
      .filterSuccessfulStatusAndRedirectCodes()
      .map(SyncResponse.self)
      .flatMap { [unowned self] _ -> Single<WatchedShowEntity> in
        return self.showProgressRepository.fetchShowProgress(ids: show.ids).map { $0.createEntity(using: show) }
      }.observeOn(schedulers.dataSourceScheduler)
      .do(onSuccess: { [unowned self] newWatchedShowEntity in
        try self.dataSource.updateWatched(show: newWatchedShowEntity)
      }).map { newWatchedShowEntity -> SyncResult in
        SyncResult.success(show: newWatchedShowEntity)
      }.catchError { error -> Single<SyncResult> in
        Single.just(SyncResult.fail(error: error))
      }
  }
}
