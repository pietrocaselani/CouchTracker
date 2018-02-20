import TraktSwift
import RxSwift
import Moya

final class ShowEpisodeMoyaNetwork: ShowEpisodeNetwork {
	private let trakt: TraktProvider
	private let schedulers: Schedulers

	init(trakt: TraktProvider, schedulers: Schedulers) {
		self.trakt = trakt
		self.schedulers = schedulers
	}

	func addToHistory(items: SyncItems) -> Single<SyncResponse> {
		let target = Sync.addToHistory(items: items)
		return performRequest(target)
	}

	func removeFromHistory(items: SyncItems) -> Single<SyncResponse> {
		let target = Sync.removeFromHistory(items: items)
		return performRequest(target)
	}

	private func performRequest(_ target: Sync) -> Single<SyncResponse> {
		return trakt.sync.rx.request(target)
			.observeOn(schedulers.networkScheduler)
			.filterSuccessfulStatusAndRedirectCodes()
			.map(SyncResponse.self)
	}
}
