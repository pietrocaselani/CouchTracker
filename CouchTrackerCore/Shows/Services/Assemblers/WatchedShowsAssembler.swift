import RxSwift
import TraktSwift

public final class WatchedShowsAssembler {
  private let watchedShowsRepository: WatchedShowsRepository
  private let watchedShowEntityAssembler: WatchedShowEntityAssembler
  private let schedulers: Schedulers

  public init(watchedShowsRepository: WatchedShowsRepository,
              watchedShowEntityAssembler: WatchedShowEntityAssembler,
              schedulers: Schedulers) {
    self.watchedShowsRepository = watchedShowsRepository
    self.watchedShowEntityAssembler = watchedShowEntityAssembler
    self.schedulers = schedulers
  }

  public func fetchWatchedShows(extended: Extended, hiddingSpecials: Bool) -> Observable<WatchedShowEntity> {
    let allWatchedShows = fetchAllWatchedShows(extended: extended)

    return allWatchedShows.flatMap { [weak self] show -> Observable<WatchedShowBuilder> in
      guard let strongSelf = self else { return Observable.empty() }
      return strongSelf.watchedShowEntityAssembler.fetchProgress(for: show, hiddingSpecials: hiddingSpecials)
    }.map { $0.createEntity() }
  }

  private func fetchAllWatchedShows(extended: Extended) -> Observable<BaseShow> {
    return watchedShowsRepository.fetchWatchedShows(extended: extended)
      .asObservable()
      .observeOn(schedulers.networkScheduler)
      .flatMap { Observable.from($0) }
  }
}
