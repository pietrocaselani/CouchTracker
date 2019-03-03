import RxSwift
import TraktSwift

public final class ShowsProgressService: ShowsProgressInteractor {
  private let listStateDataSource: ShowsProgressListStateDataSource
  private let showsObserable: WatchedShowEntitiesObservable
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
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.listStateDataSource = listStateDataSource
    self.showsObserable = showsObserable
    self.schedulers = schedulers
  }

  public func fetchWatchedShowsProgress() -> Observable<WatchedShowEntitiesState> {
    return showsObserable.observeWatchedShows().distinctUntilChanged()
  }
}
