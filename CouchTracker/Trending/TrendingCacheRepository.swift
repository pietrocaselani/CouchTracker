import Moya
import RxSwift
import TraktSwift

final class TrendingCacheRepository: TrendingRepository {

	private let traktProvider: TraktProvider

	init(traktProvider: TraktProvider) {
		self.traktProvider = traktProvider
	}

	func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
		let scheduler = SerialDispatchQueueScheduler(qos: .background)

		return traktProvider.movies.rx.request(.trending(page: page, limit: limit, extended: .full))
				.asObservable()
				.subscribeOn(scheduler)
				.observeOn(scheduler)
				.map([TrendingMovie].self)
	}

	func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
		let scheduler = SerialDispatchQueueScheduler(qos: .background)

		return traktProvider.shows.rx.request(.trending(page: page, limit: limit, extended: .full))
				.asObservable()
				.subscribeOn(scheduler)
				.observeOn(scheduler)
				.map([TrendingShow].self)
	}
}
