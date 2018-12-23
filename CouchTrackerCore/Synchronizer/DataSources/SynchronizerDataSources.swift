import RxSwift
import TraktSwift

public protocol ShowsDataHolder {
  func save(shows: [WatchedShowEntity]) throws
}

public protocol WatchedShowEntitiesObservable {
  func observeWatchedShows() -> Observable<[WatchedShowEntity]>
}

public protocol ShowDataHolder {
  func save(show: WatchedShowEntity) throws
}

public protocol WatchedShowEntityObserable {
  func observeWatchedShow(showIds: ShowIds) -> Observable<WatchedShowEntity>
}

public protocol ShowDataSource: ShowDataHolder, WatchedShowEntityObserable {}
