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
    appStateObservable.observe().do(onNext: { [weak self] appState in
      if !appState.isLogged {
        self?.viewStateSubject.onNext(.notLogged)
      }
    }).filter { $0.isLogged }
      .flatMap { [weak self] _ -> Observable<SyncState> in
        guard let strongSelf = self else { return Observable.just(SyncState.initial) }
        return strongSelf.syncStateObservable.observe()
      }.do(onNext: { [weak self] syncState in
        let viewState = syncState.isSyncing ? ShowProgressViewState.loading : ShowProgressViewState.empty
        self?.viewStateSubject.onNext(viewState)
      }).filter { $0.isSyncing == false }
      .flatMap { [weak self] _ -> Observable<[WatchedShowEntity]> in
        guard let strongSelf = self else { return Observable.just([]) }
        return strongSelf.interactor.fetchWatchedShowsProgress()
      }.do(onNext: { [weak self] shows in
        guard let strongSelf = self else { return }

        let listState = strongSelf.interactor.listState

        let viewState = createViewState(entities: shows, listState: listState)

        self?.viewStateSubject.onNext(viewState)
      })
      .subscribe()
      .disposed(by: disposeBag)
  }
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

private func createViewState(entities: [WatchedShowEntity],
                             listState: ShowProgressListState,
                             syncState: SyncState) -> ShowProgressViewState {
  if syncState.isSyncing {
    return .loading
  }

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
