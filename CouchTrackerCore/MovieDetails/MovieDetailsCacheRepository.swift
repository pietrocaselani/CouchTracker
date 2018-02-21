import Moya
import RxSwift
import TraktSwift

public final class MovieDetailsCacheRepository: MovieDetailsRepository {
	private let traktProvider: TraktProvider
	private let schedulers: Schedulers

	public init(traktProvider: TraktProvider, schedulers: Schedulers) {
		self.traktProvider = traktProvider
		self.schedulers = schedulers
	}

	public func fetchDetails(movieId: String) -> Observable<Movie> {
		return traktProvider.movies.rx.request(.summary(movieId: movieId, extended: .full))
			.observeOn(schedulers.networkScheduler)
			.map(Movie.self)
			.asObservable()
	}
}
