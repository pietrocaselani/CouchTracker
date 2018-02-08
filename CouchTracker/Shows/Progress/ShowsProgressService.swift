import RxSwift
import TraktSwift

final class ShowsProgressService: ShowsProgressInteractor {
  private let repository: ShowsProgressRepository
  private let schedulers: Schedulers

  init(repository: ShowsProgressRepository, schedulers: Schedulers) {
    self.repository = repository
    self.schedulers = schedulers
  }

  func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]> {
    return repository.fetchWatchedShows(extended: .fullEpisodes)
      .distinctUntilChanged({ (lhs, rhs) -> Bool in
        guard lhs.count == rhs.count else { return false }
        let equals = lhs == rhs
        return equals
      })
  }
}
