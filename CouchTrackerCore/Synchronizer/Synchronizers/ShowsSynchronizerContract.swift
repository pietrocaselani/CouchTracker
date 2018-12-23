import RxSwift
import TraktSwift

public protocol WatchedShowsSynchronizer {
  func syncWatchedShows(using options: WatchedShowEntitiesSyncOptions) -> Single<[WatchedShowEntity]>
}

public protocol WatchedShowSynchronizer {
  func syncWatchedShow(using options: WatchedShowEntitySyncOptions) -> Single<WatchedShowEntity>
}
