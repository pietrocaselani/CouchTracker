import RxSwift
import TraktSwift

public protocol ShowsProgressDataSource: class {
  func fetchWatchedShows() -> Observable<[WatchedShowEntity]>
  func addWatched(shows: [WatchedShowEntity]) throws
}

public protocol ShowsProgressListStateDataSource: class {
  var currentState: ShowProgressListState { get set }
}

public protocol ShowsProgressInteractor: class {
  var listState: Observable<ShowProgressListState> { get }

  func fetchWatchedShowsProgress() -> Observable<WatchedShowEntitiesState>
  func toggleDirection() -> Completable
  func change(sort: ShowProgressSort, filter: ShowProgressFilter) -> Completable
}

public protocol ShowsProgressRouter: class {
  func show(tvShow entity: WatchedShowEntity)
}

public protocol ShowsProgressPresenter: class {
  func observeViewState() -> Observable<ShowProgressViewState>

  func change(sort: ShowProgressSort, filter: ShowProgressFilter) -> Completable
  func toggleDirection() -> Completable
  func select(show: WatchedShowEntity)
}
