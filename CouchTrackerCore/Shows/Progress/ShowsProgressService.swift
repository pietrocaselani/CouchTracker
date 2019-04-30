import RxSwift
import TraktSwift

public final class ShowsProgressService: ShowsProgressInteractor {
  private let listStateSubject: BehaviorSubject<ShowProgressListState>
  private let listStateDataSource: ShowsProgressListStateDataSource
  private let showsObserable: WatchedShowEntitiesObservable
  private let schedulers: Schedulers

  public var listState: Observable<ShowProgressListState>

  public init(listStateDataSource: ShowsProgressListStateDataSource,
              showsObserable: WatchedShowEntitiesObservable,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.listStateDataSource = listStateDataSource
    self.showsObserable = showsObserable
    self.schedulers = schedulers
    listStateSubject = BehaviorSubject<ShowProgressListState>(value: listStateDataSource.currentState)
    listState = listStateSubject.distinctUntilChanged()
  }

  public func fetchWatchedShowsProgress() -> Observable<WatchedShowEntitiesState> {
    return showsObserable.observeWatchedShows().distinctUntilChanged()
  }

  public func toggleDirection() -> Completable {
    let listState = listStateDataSource.currentState.builder().toggleDirection().build()
    newListState(listState: listState)
    return Completable.empty()
  }

  public func change(sort: ShowProgressSort, filter: ShowProgressFilter) -> Completable {
    let listState = listStateDataSource.currentState.builder().filter(filter).sort(sort).build()
    newListState(listState: listState)
    return Completable.empty()
  }

  private func newListState(listState: ShowProgressListState) {
    listStateDataSource.currentState = listState
    listStateSubject.onNext(listState)
  }
}
