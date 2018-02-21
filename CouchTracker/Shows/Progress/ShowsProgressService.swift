import RxSwift
import TraktSwift

public final class ShowsProgressService: ShowsProgressInteractor {
	private let repository: ShowsProgressRepository
	private let schedulers: Schedulers

	public init(repository: ShowsProgressRepository, schedulers: Schedulers) {
		self.repository = repository
		self.schedulers = schedulers
	}

	public func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]> {
		return repository.fetchWatchedShows(extended: .fullEpisodes)
			.distinctUntilChanged({ (lhs, rhs) -> Bool in
				guard lhs.count == rhs.count else { return false }
				let equals = lhs == rhs
				return equals
			})
	}
}
