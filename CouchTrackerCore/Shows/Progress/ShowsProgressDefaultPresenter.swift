import NonEmpty
import RxSwift

public final class ShowsProgressDefaultPresenter: ShowsProgressPresenter {
  private let viewStateSubject = BehaviorSubject<ShowProgressViewState>(value: .empty)
  private let disposeBag = DisposeBag()

  private let interactor: ShowsProgressInteractor
  private let router: ShowsProgressRouter

  public init(interactor: ShowsProgressInteractor,
              router: ShowsProgressRouter,
              loginObservable: TraktLoginObservable) {
    self.interactor = interactor
    self.router = router

    loginObservable.observe()
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] loginState in
        if loginState == .notLogged {
          self?.viewStateSubject.onNext(.notLogged)
        } else {
          self?.fetchShows()
        }
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

  public func change(sort: ShowProgressSort, filter: ShowProgressFilter) {
    guard let currentViewState = try? viewStateSubject.value(),
      case let ShowProgressViewState.shows(entities, _) = currentViewState else { return }

    let newListState = interactor.listState.builder().sort(sort).filter(filter).build()

    interactor.listState = newListState

    let newViewState = createViewState(entities: Array(entities), listState: newListState)

    viewStateSubject.onNext(newViewState)
  }

  public func select(show: WatchedShowEntity) {
    router.show(tvShow: show)
  }

  private func fetchShows() {
    interactor.fetchWatchedShowsProgress()
      .map { [weak self] entities -> ShowProgressViewState in
        guard let listState = self?.interactor.listState else { return .empty }
        return createViewState(entities: entities, listState: listState)
      }
      .ifEmpty(default: .empty)
      .catchError { error -> Observable<ShowProgressViewState> in
        Observable.just(ShowProgressViewState.error(error: error))
      }
      .do(onSubscribe: { [weak self] in
        self?.viewStateSubject.onNext(.loading)
      })
      .subscribe(onNext: { [weak self] newViewState in
        self?.viewStateSubject.onNext(newViewState)
      }).disposed(by: disposeBag)
  }
}

private func createViewState(entities: [WatchedShowEntity],
                             listState: ShowProgressListState) -> ShowProgressViewState {
  var newEntities = entities.filter(listState.filter.filter()).sorted(by: listState.sort.comparator())

  if listState.direction == .desc {
    newEntities = newEntities.reversed()
  }

  guard let headEntity = newEntities.first else { return .empty }

  let nonEmptyEntities = NonEmptyArray<WatchedShowEntity>(headEntity, Array(newEntities.dropFirst()))

  let menu = ShowsProgressMenuOptions(sort: ShowProgressSort.allValues(),
                                      filter: ShowProgressFilter.allValues(),
                                      currentFilter: listState.filter,
                                      currentSort: listState.sort)

  return .shows(entities: nonEmptyEntities, menu: menu)
}
