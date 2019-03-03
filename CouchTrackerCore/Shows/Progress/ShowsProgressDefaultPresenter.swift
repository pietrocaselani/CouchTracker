import NonEmpty
import RxSwift

public final class ShowsProgressDefaultPresenter: ShowsProgressPresenter {
  private let viewStateSubject = BehaviorSubject<ShowProgressViewState>(value: .notLogged)
  private let disposeBag = DisposeBag()
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
    return viewStateSubject.distinctUntilChanged()
  }

  public func viewDidLoad() {
    fetchShows()
  }

  public func toggleDirection() {
    let currentListState = interactor.listState
    let newListState = currentListState.builder().direction(currentListState.direction.toggle()).build()
    interactor.listState = newListState

    fetchShows()
  }

  public func change(sort: ShowProgressSort, filter: ShowProgressFilter) {
    let newListState = interactor.listState.builder().sort(sort).filter(filter).build()
    interactor.listState = newListState

    fetchShows()
  }

  public func select(show: WatchedShowEntity) {
    router.show(tvShow: show)
  }

  private func fetchShows() {
    let appStateStream = appStateObservable.observe()
    let syncStateStream = syncStateObservable.observe()

    Observable.combineLatest(appStateStream,
                             syncStateStream) { (appState, syncState) -> AllStates in
      return AllStates(appState: appState, syncState: syncState)
    }.flatMap { [weak self] states -> Observable<ShowProgressViewState> in
      guard states.appState.isLogged else { return .just(.notLogged) }

      guard let strongSelf = self else { return .just(.loading) }

      let defaultViewState: ShowProgressViewState = states.syncState.isSyncing ? .loading : .empty

      let listState = strongSelf.interactor.listState

      return strongSelf.interactor.fetchWatchedShowsProgress()
        .map { showsState -> ShowProgressViewState in
          switch showsState {
          case .unavailable: return defaultViewState
          case let .available(shows):
            return createViewState(entities: shows, listState: listState)
          }
        }
    }
    .catchError { error -> Observable<ShowProgressViewState> in
      return .just(ShowProgressViewState.error(error: error))
    }.subscribe(onNext: { [weak self] viewState in
      self?.viewStateSubject.onNext(viewState)
    }).disposed(by: disposeBag)
  }
}

private struct AllStates {
  let appState: AppState
  let syncState: SyncState
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

  guard let headEntity = newEntities.first else { return .filterEmpty }

  let nonEmptyEntities = NonEmptyArray<WatchedShowEntity>(headEntity, Array(newEntities.dropFirst()))

  let menu = ShowsProgressMenuOptions(sort: ShowProgressSort.allValues(),
                                      filter: ShowProgressFilter.allValues(),
                                      currentFilter: listState.filter,
                                      currentSort: listState.sort)

  return .shows(entities: nonEmptyEntities, menu: menu)
}
