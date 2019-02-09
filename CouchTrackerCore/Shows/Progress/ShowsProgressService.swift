import RxSwift
import TraktSwift

public final class ShowsProgressService: ShowsProgressInteractor {
  private let listStateDataSource: ShowsProgressListStateDataSource
  private let showsObserable: WatchedShowEntitiesObservable
  private let syncStateObservable: SyncStateObservable
  private let appStateObservable: AppStateObservable
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
              appStateObservable: AppStateObservable,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.listStateDataSource = listStateDataSource
    self.showsObserable = showsObserable
    self.syncStateObservable = syncStateObservable
    self.appStateObservable = appStateObservable
    self.schedulers = schedulers
  }

  public func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]> {
    return appStateObservable.observe()
      .filter { $0.isLogged }
      .flatMap { [weak self] appState -> Observable<ShowsState> in
        guard let strongSelf = self else {
          return Observable.just(ShowsState(isLogged: appState.isLogged))
        }

        return strongSelf.syncStateObservable.observe().map {
          ShowsState(isSyncing: $0.isSyncing, isLogged: appState.isLogged)
        }
      }.filter { $0.isSyncing == false && $0.isLogged }
      .flatMap { [weak self] _ -> Observable<[WatchedShowEntity]> in
        guard let strongSelf = self else { return Observable.just([WatchedShowEntity]()) }

        return strongSelf.showsObserable.observeWatchedShows().distinctUntilChanged()
      }
  }

  struct ShowsState: Hashable {
    let shows: [WatchedShowEntity]
    let isSyncing, isLogged: Bool

    init(isSyncing: Bool = false, isLogged: Bool = false, shows: [WatchedShowEntity] = []) {
      self.isSyncing = isSyncing
      self.isLogged = isLogged
      self.shows = shows
    }
  }
}
