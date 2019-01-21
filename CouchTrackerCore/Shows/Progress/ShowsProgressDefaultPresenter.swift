import NonEmpty
import RxSwift

public final class ShowsProgressDefaultPresenter: ShowsProgressPresenter {
  private let viewStateSubject = BehaviorSubject<ShowProgressViewState>(value: .loading)
  private let disposeBag = DisposeBag()
  private let interactor: ShowsProgressInteractor
  private let router: ShowsProgressRouter
  private let syncStateObservable: SyncStateObservable

  public init(interactor: ShowsProgressInteractor,
              router: ShowsProgressRouter,
              loginObservable: TraktLoginObservable,
              syncStateObservable: SyncStateObservable) {
    self.interactor = interactor
    self.router = router
    self.syncStateObservable = syncStateObservable

    loginObservable.observe()
      .subscribe(onNext: { [weak self] loginState in
        if loginState == .notLogged {
          self?.viewStateSubject.onNext(.notLogged)
        } else {
          self?.fetchShows()
        }
      }).disposed(by: disposeBag)

    syncStateObservable.observe().subscribe(onNext: { syncState in
      print("ViewState IsSync = \(syncState.isSyncing)")
    }).disposed(by: disposeBag)
  }

  public func observeViewState() -> Observable<ShowProgressViewState> {
    /* CT-TODO
     This view state should be tied to SynchonizationState,
     that will be implemented in a near future.
     This is necessary to avoid a flow state
     NotLogged -> Loading -> Empty -> Data
     because realm emits empty and then, the sync finishes and realm will emit data
     */
    return viewStateSubject.distinctUntilChanged()
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
    let showsObservable = interactor.fetchWatchedShowsProgress()
    let syncStateStream = syncStateObservable.observe()
    Observable.combineLatest(syncStateStream, showsObservable) { [weak self] syncState, entities in
      guard let strongSelf = self else { return .empty }

      let listState = strongSelf.interactor.listState
      return createViewState(entities: entities, listState: listState, syncState: syncState)
    }.ifEmpty(default: .empty)
      .catchError { error -> Observable<ShowProgressViewState> in
        Observable.just(ShowProgressViewState.error(error: error))
      }
      .subscribe(onNext: { [weak self] newViewState in
        self?.viewStateSubject.onNext(newViewState)
      }).disposed(by: disposeBag)
  }
}

private func createViewState(entities: [WatchedShowEntity],
                             listState: ShowProgressListState,
                             syncState: SyncState) -> ShowProgressViewState {
  if syncState.isSyncing {
    print("ViewState if do isSyncing")
    return .loading
  }

  if entities.isEmpty {
    print("ViewState if do isEmpty")
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
