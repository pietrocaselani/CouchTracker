import RxSwift
import TraktSwift

public final class DefaultWatchedShowsSynchronizer: WatchedShowsSynchronizer {
  private let trakt: TraktProvider
  private let dataSource: ShowsDataSource
  private let schedulers: Schedulers

  public init(trakt: TraktProvider, dataSource: ShowsDataSource, schedulers: Schedulers) {
    self.trakt = trakt
    self.dataSource = dataSource
    self.schedulers = schedulers
  }

  public func syncWatchedShows(extended _: Extended, options _: ShowSyncOptions) -> Observable<WatchedShowEntity> {
    return Observable.empty()
  }
}
