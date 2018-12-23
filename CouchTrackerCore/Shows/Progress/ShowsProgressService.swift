import RxSwift
import TraktSwift

public final class ShowsProgressService: ShowsProgressInteractor {
  private let listStateDataSource: ShowsProgressListStateDataSource
  private let showsObserable: WatchedShowEntitiesObservable

  public var listState: ShowProgressListState {
    get {
      return listStateDataSource.currentState
    }
    set {
      listStateDataSource.currentState = newValue
    }
  }

  public init(listStateDataSource: ShowsProgressListStateDataSource,
              showsObserable: WatchedShowEntitiesObservable) {
    self.listStateDataSource = listStateDataSource
    self.showsObserable = showsObserable
  }

  public func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]> {
    return showsObserable.observeWatchedShows().distinctUntilChanged()
  }
}
