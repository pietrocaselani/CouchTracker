import NonEmpty
import RxSwift

public final class ShowsProgressDefaultPresenter: ShowsProgressPresenter {
  private let viewStateSubject = BehaviorSubject<ShowProgressViewState>(value: .notLogged)
  private let disposeBag = DisposeBag()
  private let interactor: ShowsProgressInteractor
  private let router: ShowsProgressRouter
  private let syncStateObservable: SyncStateObservable
  private let appConfigsObservable: AppStateObservable

  public init(interactor: ShowsProgressInteractor,
              router: ShowsProgressRouter,
              appConfigsObservable: AppStateObservable,
              syncStateObservable: SyncStateObservable) {
    self.interactor = interactor
    self.router = router
    self.syncStateObservable = syncStateObservable
    self.appConfigsObservable = appConfigsObservable
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
    Observable.combineLatest(syncStateObservable.observe(),
                             interactor.fetchWatchedShowsProgress(),
                             appConfigsObservable.observe()) { [weak self] syncState, entities, loginState in
      guard let strongSelf = self else { return .empty }

      guard loginState.isLogged else { return ShowProgressViewState.notLogged }

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
