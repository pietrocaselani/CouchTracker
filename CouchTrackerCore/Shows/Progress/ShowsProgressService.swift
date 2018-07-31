import RxSwift
import TraktSwift

public final class ShowsProgressService: ShowsProgressInteractor {
  private let repository: ShowsProgressRepository
  private let listStateDataSource: ShowsProgressListStateDataSource
  private let schedulers: Schedulers

  public var listState: ShowProgressListState {
    get {
      return listStateDataSource.currentState
    }
    set {
      listStateDataSource.currentState = newValue
    }
  }

  public init(repository: ShowsProgressRepository,
              listStateDataSource: ShowsProgressListStateDataSource,
              schedulers: Schedulers) {
    self.repository = repository
    self.listStateDataSource = listStateDataSource
    self.schedulers = schedulers
  }

  public func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]> {
    return repository.fetchWatchedShows(extended: .fullEpisodes)
      .distinctUntilChanged({ (lhs, rhs) -> Bool in
        lhs == rhs
      })
  }
}
