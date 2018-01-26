import Moya
import RxSwift
import TraktSwift

final class TrendingCacheRepository: TrendingRepository {
	private let traktProvider: TraktProvider
	private let scheduler: SchedulerType

	init(traktProvider: TraktProvider, scheduler: SchedulerType = SerialDispatchQueueScheduler(qos: .background)) {
		self.traktProvider = traktProvider
		self.scheduler = scheduler
	}

	func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
		return traktProvider.movies.rx.request(.trending(page: page, limit: limit, extended: .full))
				.asObservable()
				.subscribeOn(scheduler)
				.observeOn(scheduler)
				.map([TrendingMovie].self)
	}

	func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
		return traktProvider.shows.rx.request(.trending(page: page, limit: limit, extended: .full))
				.asObservable()
				.subscribeOn(scheduler)
				.observeOn(scheduler)
				.map([TrendingShow].self)
	}
}
