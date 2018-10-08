import RxSwift
import TraktSwift

public protocol ShowsDataSource {
  func observeWatchedShows() -> Observable<[WatchedShowEntity]>
  func save(shows: [WatchedShowEntity]) throws
}

public protocol ShowDataSource {
  func observeWatchedShow(showIds: ShowIds) -> Observable<WatchedShowEntity>
}
