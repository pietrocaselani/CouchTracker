import RxSwift
import Moya
import TraktSwift

public final class ShowOverviewAPIRepository: ShowOverviewRepository {
	private let traktProvider: TraktProvider
	private let schedulers: Schedulers

	public init(traktProvider: TraktProvider, schedulers: Schedulers) {
		self.traktProvider = traktProvider
		self.schedulers = schedulers
	}

	public func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
		return traktProvider.shows.rx.request(.summary(showId: identifier, extended: extended))
			.observeOn(schedulers.networkScheduler)
			.map(Show.self)
	}
}
