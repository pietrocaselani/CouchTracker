import RxSwift
import TraktSwift

public protocol ShowsProgressDataSource: class {
  func fetchWatchedShows() -> Observable<[WatchedShowEntity]>
  func addWatched(shows: [WatchedShowEntity]) throws
}

public protocol ShowsProgressListStateDataSource: class {
  var currentState: ShowProgressListState { get set }
}

public protocol ShowsProgressRepository: class {
  func fetchWatchedShowsProgress(extended: Extended, hiddingSpecials: Bool) -> Observable<[WatchedShowEntity]>
  func reload(extended: Extended, hiddingSpecials: Bool) -> Completable
}

public protocol ShowsProgressInteractor: class {
  var listState: ShowProgressListState { get set }

  func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]>
}

public protocol ShowsProgressRouter: class {
  func show(tvShow entity: WatchedShowEntity)
}

public protocol ShowsProgressPresenter: class {
  func observeViewState() -> Observable<ShowProgressViewState>

  func change(sort: ShowProgressSort, filter: ShowProgressFilter)
  func select(show: WatchedShowEntity)
}
