import RxSwift

public final class ShowsProgressDefaultPresenter: ShowsProgressPresenter {
  private let interactor: ShowsProgressInteractor
  private let router: ShowsProgressRouter
  private let syncStateObservable: SyncStateObservable
  private let appStateObservable: AppStateObservable

  public init(interactor: ShowsProgressInteractor,
              router: ShowsProgressRouter,
              appStateObservable: AppStateObservable,
              syncStateObservable: SyncStateObservable) {
    self.interactor = interactor
    self.router = router
    self.syncStateObservable = syncStateObservable
    self.appStateObservable = appStateObservable
  }

  public func observeViewState() -> Observable<ShowProgressViewState> {
    let appStateStream = appStateObservable.observe()
    let syncStateStream = syncStateObservable.observe()
    let listStateStream = interactor.listState

    return Observable.combineLatest(appStateStream,
                                    syncStateStream,
                                    listStateStream) { (appState, syncState, listState) -> AllStates in
      AllStates(appState: appState, syncState: syncState, listState: listState)
    }.flatMap { [weak self] states -> Observable<ShowProgressViewState> in
      guard states.appState.isLogged else { return .just(.notLogged) }

      guard let strongSelf = self else { return .just(.loading) }

      let defaultViewState: ShowProgressViewState = states.syncState.isSyncing ? .loading : .empty

      return strongSelf.interactor.fetchWatchedShowsProgress()
        .map { showsState -> ShowProgressViewState in
          switch showsState {
          case .unavailable: return defaultViewState
          case let .available(shows):
            return createViewState(entities: shows, listState: states.listState)
          }
        }
    }
    .catchError { error -> Observable<ShowProgressViewState> in
      .just(ShowProgressViewState.error(error: error))
    }
  }

  public func toggleDirection() -> Completable {
    return interactor.toggleDirection()
  }

  public func change(sort: ShowProgressSort, filter: ShowProgressFilter) -> Completable {
    return interactor.change(sort: sort, filter: filter)
  }

  public func select(show: WatchedShowEntity) {
    router.show(tvShow: show)
  }
}

private struct AllStates {
  let appState: AppState
  let syncState: SyncState
  let listState: ShowProgressListState
}

private func createViewState(entities: [WatchedShowEntity],
                             listState: ShowProgressListState) -> ShowProgressViewState {
  if entities.isEmpty {
    return .empty
  }

  var newEntities = entities.filter(listState.filter.filter()).sorted(by: listState.sort.comparator())

  if listState.direction == .desc {
    newEntities = newEntities.reversed()
  }

    guard !newEntities.isEmpty else { return .filterEmpty }

  let menu = ShowsProgressMenuOptions(sort: ShowProgressSort.allValues(),
                                      filter: ShowProgressFilter.allValues(),
                                      currentFilter: listState.filter,
                                      currentSort: listState.sort)

  return .shows(entities: newEntities, menu: menu)
}
