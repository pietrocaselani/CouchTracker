import RxSwift
import TraktSwift

public enum WatchedShowEntitiesState: Hashable {
  case unavailable
  case available(shows: [WatchedShowEntity])
}

public protocol ShowsDataHolder {
  func save(show: WatchedShowEntity) throws
  func save(shows: [WatchedShowEntity]) throws
}

public protocol WatchedShowEntitiesObservable {
  func observeWatchedShows() -> Observable<WatchedShowEntitiesState>
}

public protocol ShowDataHolder {
  func save(show: WatchedShowEntity) throws
}

public protocol WatchedShowEntityObserable {
  func observeWatchedShow(showIds: ShowIds) -> Observable<WatchedShowEntity>
}

public protocol ShowDataSource: ShowDataHolder, WatchedShowEntityObserable {}
