import RxSwift
import TraktSwift

public final class DefaultWatchedShowsSynchronizer: WatchedShowsSynchronizer {
  private let downloader: WatchedShowEntitiesDownloader
  private let dataHolder: ShowsDataHolder
  private let schedulers: Schedulers

  public init(downloader: WatchedShowEntitiesDownloader,
              dataHolder: ShowsDataHolder,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.downloader = downloader
    self.dataHolder = dataHolder
    self.schedulers = schedulers
  }

  public func syncWatchedShows(using options: WatchedShowEntitiesSyncOptions) -> Single<[WatchedShowEntity]> {
    downloader.syncWatchedShowEntities(using: options)
      .observeOn(schedulers.networkScheduler)
      .toArray()
      .observeOn(schedulers.dataSourceScheduler)
      .do(onSuccess: { [weak self] shows in
        guard let strongSelf = self else { return }
        try strongSelf.dataHolder.save(shows: shows)
      })
  }
}
