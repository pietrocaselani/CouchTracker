import Moya
import RxSwift
import TraktSwift

final class TraktGenreRepository: GenreRepository {
	private let traktProvider: TraktProvider
	private let schedulers: Schedulers

	init(traktProvider: TraktProvider, schedulers: Schedulers) {
		self.traktProvider = traktProvider
		self.schedulers = schedulers
	}

	func fetchMoviesGenres() -> Observable<[Genre]> {
		return fetchGenres(mediaType: .movies)
	}

	func fetchShowsGenres() -> Observable<[Genre]> {
		return fetchGenres(mediaType: .shows)
	}

	private func fetchGenres(mediaType: GenreType) -> Observable<[Genre]> {
		return traktProvider.genres.rx.request(.list(mediaType))
			.observeOn(schedulers.networkScheduler)
			.map([Genre].self)
			.asObservable()
	}
}
