import Moya
import RxSwift
import TraktSwift

final class TrendingCacheRepository: TrendingRepository {
//  private let moviesCache: BasicCache<Movies, [TrendingMovie]>
//  private let showsCache: BasicCache<Shows, [TrendingShow]>

	private let traktProvider: TraktProvider

	init(traktProvider: TraktProvider) {
		self.traktProvider = traktProvider
//    let moviesProvider = traktProvider.movies
//    let showsProvider = traktProvider.shows
//    self.moviesCache = MemoryCacheLevel<Movies, NSData>()
//      .compose(DiskCacheLevel<Movies, NSData>())
//      .compose(MoyaFetcher(provider: moviesProvider))
//      .transformValues(JSONArrayTransfomer<TrendingMovie>())
//
//    self.showsCache = MemoryCacheLevel<Shows, NSData>()
//      .compose(DiskCacheLevel<Shows, NSData>())
//      .compose(MoyaFetcher(provider: showsProvider))
//      .transformValues(JSONArrayTransfomer<TrendingShow>())
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
