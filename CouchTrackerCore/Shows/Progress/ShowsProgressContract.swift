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
  var listState: ShowProgressListState { get set }

  func fetchWatchedShowsProgress() -> Observable<WatchedShowEntitiesState>
}

public protocol ShowsProgressRouter: class {
  func show(tvShow entity: WatchedShowEntity)
}

public protocol ShowsProgressPresenter: class {
  func observeViewState() -> Observable<ShowProgressViewState>
  func viewDidLoad()

  func change(sort: ShowProgressSort, filter: ShowProgressFilter)
  func toggleDirection()
  func select(show: WatchedShowEntity)
}
