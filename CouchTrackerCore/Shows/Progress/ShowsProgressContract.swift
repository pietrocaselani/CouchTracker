import RxSwift
import TraktSwift

public protocol ShowsProgressDataSource: AnyObject {
  func fetchWatchedShows() -> Observable<[WatchedShowEntity]>
  func addWatched(shows: [WatchedShowEntity]) throws
}

public protocol ShowsProgressListStateDataSource: AnyObject {
  var currentState: ShowProgressListState { get set }
}

public protocol ShowsProgressInteractor: AnyObject {
  var listState: Observable<ShowProgressListState> { get }

  func fetchWatchedShowsProgress() -> Observable<WatchedShowEntitiesState>
  func toggleDirection() -> Completable
  func change(sort: ShowProgressSort, filter: ShowProgressFilter) -> Completable
}

public protocol ShowsProgressRouter: AnyObject {
  func show(tvShow entity: WatchedShowEntity)
}

public protocol ShowsProgressPresenter: AnyObject {
  func observeViewState() -> Observable<ShowProgressViewState>

  func change(sort: ShowProgressSort, filter: ShowProgressFilter) -> Completable
  func toggleDirection() -> Completable
  func select(show: WatchedShowEntity)
}
