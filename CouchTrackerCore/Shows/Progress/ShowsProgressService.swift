import RxSwift
import TraktSwift

public final class ShowsProgressService: ShowsProgressInteractor {
  private let listStateDataSource: ShowsProgressListStateDataSource
  private let showsObserable: WatchedShowEntitiesObservable
  private let syncStateObservable: SyncStateObservable
  private let appConfigsObservable: AppStateObservable
  private let schedulers: Schedulers

  public var listState: ShowProgressListState {
    get {
      return listStateDataSource.currentState
    }
    set {
      listStateDataSource.currentState = newValue
    }
  }

  public init(listStateDataSource: ShowsProgressListStateDataSource,
              showsObserable: WatchedShowEntitiesObservable,
              syncStateObservable: SyncStateObservable,
              appConfigsObservable: AppStateObservable,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.listStateDataSource = listStateDataSource
    self.showsObserable = showsObserable
    self.syncStateObservable = syncStateObservable
    self.appConfigsObservable = appConfigsObservable
    self.schedulers = schedulers
  }

  public func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]> {
    let showsObservable = showsObserable.observeWatchedShows().distinctUntilChanged()
    let isSyncingObservable = syncStateObservable.observe().map { $0.isSyncing }
    let isLoggedObservable = appConfigsObservable.observe().map { $0.isLogged }

    return Observable.combineLatest(showsObservable,
                                    isSyncingObservable,
                                    isLoggedObservable) { (shows, isSyncing, isLogged) -> ShowsState in
      ShowsState(shows: shows, isSyncing: isSyncing, isLogged: isLogged)
    }.distinctUntilChanged()
      .filter { state -> Bool in
        !state.isSyncing && state.isLogged
      }.map { state -> [WatchedShowEntity] in
        state.shows
      }
  }

  struct ShowsState: Hashable {
    let shows: [WatchedShowEntity]
    let isSyncing, isLogged: Bool
  }
}
