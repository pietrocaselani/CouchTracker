import RxSwift
import TraktSwift

public protocol WatchedShowEntityDownloader {
  func syncWatchedShowEntitiy(using options: WatchedShowEntitySyncOptions) -> Single<WatchedShowBuilder>
}

public protocol WatchedShowEntitiesDownloader {
  func syncWatchedShowEntities(using options: WatchedShowEntitiesSyncOptions) -> Observable<WatchedShowEntity>
}
