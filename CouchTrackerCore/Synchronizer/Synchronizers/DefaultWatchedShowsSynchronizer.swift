import RxSwift
import TraktSwift

public final class DefaultWatchedShowsSynchronizer: WatchedShowsSynchronizer {
  private let downloader: WatchedShowEntitiesDownloader
  private let dataHolder: ShowsDataHolder
  private let schedulers: Schedulers
  private let syncStateOutput: SyncStateOutput

  public init(downloader: WatchedShowEntitiesDownloader,
              dataHolder: ShowsDataHolder,
              syncStateOutput: SyncStateOutput,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.downloader = downloader
    self.dataHolder = dataHolder
    self.syncStateOutput = syncStateOutput
    self.schedulers = schedulers
  }

  public func syncWatchedShows(using options: WatchedShowEntitiesSyncOptions) -> Single<[WatchedShowEntity]> {
    return downloader.syncWatchedShowEntities(using: options)
      .debug(">>> [Sync]", trimOutput: false)
      .notifySyncState(syncStateOutput)
      .observeOn(schedulers.networkScheduler)
      .toArray()
      .observeOn(schedulers.dataSourceScheduler)
      .do(onNext: { [weak self] shows in
        guard let strongSelf = self else { return }
        try strongSelf.dataHolder.save(shows: shows)
      }).asSingle()
  }
}
