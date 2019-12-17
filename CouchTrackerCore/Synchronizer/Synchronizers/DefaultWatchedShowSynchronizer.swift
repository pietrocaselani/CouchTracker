import RxSwift
import TraktSwift

public final class DefaultWatchedShowSynchronizer: WatchedShowSynchronizer {
  private let downloader: WatchedShowEntityDownloader
  private let dataSource: ShowDataSource
  private let scheduler: Schedulers

  public init(downloader: WatchedShowEntityDownloader,
              dataSource: ShowDataSource,
              scheduler: Schedulers = DefaultSchedulers.instance) {
    self.downloader = downloader
    self.dataSource = dataSource
    self.scheduler = scheduler
  }

  public func syncWatchedShow(using options: WatchedShowEntitySyncOptions) -> Single<WatchedShowEntity> {
    let localObservable = fetchCurrentEntity(options.showIds).map(Container.value).ifEmpty(default: Container.empty)
    let remoteObservable = downloadEntity(options).map(Container.value)

    return Observable.zip(localObservable, remoteObservable) {
      try DefaultWatchedShowSynchronizer.merge(old: $0, with: $1)
    }.observeOn(scheduler.dataSourceScheduler)
      .do(onNext: { [dataSource] show in
        try dataSource.save(show: show)
      }).asSingle()
  }

  private func fetchCurrentEntity(_ showIds: ShowIds) -> Observable<WatchedShowEntity> {
    return dataSource.observeWatchedShow(showIds: showIds)
  }

  private func downloadEntity(_ options: WatchedShowEntitySyncOptions) -> Observable<WatchedShowEntity> {
    return downloader.syncWatchedShowEntitiy(using: options)
      .observeOn(scheduler.networkScheduler)
      .map { $0.createEntity() }
      .asObservable()
  }

  private static func merge(old: Container<WatchedShowEntity>,
                            with current: Container<WatchedShowEntity>) throws -> WatchedShowEntity {
    let (oldShow, currentShow) = try old.value
      .flatMap(with: current.value)
      .orThrow(error: CouchTrackerError.watchedShowSyncMergeError)

    return DefaultWatchedShowSynchronizer.merge(old: oldShow, with: currentShow)
  }

  private static func merge(old: WatchedShowEntity, with current: WatchedShowEntity) -> WatchedShowEntity {
    let newSeasons = mergeSeasons(old: old.seasons, current: current.seasons)

    return WatchedShowEntity(show: old.show,
                             aired: current.aired,
                             completed: current.completed,
                             nextEpisode: current.nextEpisode,
                             lastWatched: current.lastWatched,
                             seasons: newSeasons)
  }

  private static func mergeSeasons(old: [WatchedSeasonEntity],
                                   current: [WatchedSeasonEntity]) -> [WatchedSeasonEntity] {
    return old.map { oldSeason -> WatchedSeasonEntity in
      guard let currentSeason = current.first(where: { $0.number == oldSeason.number }) else { return oldSeason }

      return WatchedSeasonEntity(showIds: oldSeason.showIds,
                                 seasonIds: oldSeason.seasonIds,
                                 number: oldSeason.number,
                                 aired: currentSeason.aired,
                                 completed: currentSeason.completed,
                                 episodes: currentSeason.episodes,
                                 overview: oldSeason.overview,
                                 title: currentSeason.title)
    }
  }
}
