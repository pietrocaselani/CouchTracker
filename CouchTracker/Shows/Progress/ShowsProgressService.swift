import RxSwift
import TraktSwift

final class ShowsProgressService: ShowsProgressInteractor {
  private let repository: ShowsProgressRepository
  private let schedulers: Schedulers

  init(repository: ShowsProgressRepository, schedulers: Schedulers) {
    self.repository = repository
    self.schedulers = schedulers
  }

  func fetchWatchedShowsProgress(update: Bool) -> Observable<WatchedShowEntity> {
    return repository.fetchWatchedShows(update: update, extended: .fullEpisodes)
  }
}
