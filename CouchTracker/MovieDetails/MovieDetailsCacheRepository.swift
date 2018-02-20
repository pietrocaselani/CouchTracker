import Moya
import RxSwift
import TraktSwift

final class MovieDetailsCacheRepository: MovieDetailsRepository {
	private let traktProvider: TraktProvider
	private let schedulers: Schedulers

	init(traktProvider: TraktProvider, schedulers: Schedulers) {
		self.traktProvider = traktProvider
		self.schedulers = schedulers
	}

	func fetchDetails(movieId: String) -> Observable<Movie> {
		return traktProvider.movies.rx.request(.summary(movieId: movieId, extended: .full))
			.observeOn(schedulers.networkScheduler)
			.map(Movie.self)
			.asObservable()
	}
}
