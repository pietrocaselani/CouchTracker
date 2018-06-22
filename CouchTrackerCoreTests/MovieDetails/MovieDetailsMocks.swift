import Foundation
import RxSwift
import TraktSwift
@testable import CouchTrackerCore

final class MovieDetailsMocks {
	private init() {}

	final class Interactor: MovieDetailsInteractor {
		var toggleWatchedInvokedCount = 0

		func fetchDetails() -> Observable<MovieEntity> {
			let entity = MovieEntityMapper.entity(for: TraktEntitiesMock.createMovieDetailsMock())
			return Observable.just(entity)
		}

		func fetchImages() -> Maybe<ImagesEntity> {
			return Maybe.empty()
		}

		func toggleWatched(movie: MovieEntity) -> Completable {
			toggleWatchedInvokedCount += 1
			return Completable.empty()
		}
	}

	final class MovieDetailsRepositoryMock: MovieDetailsRepository {
		private let watched: Bool
		private let error: Error?
		var addToHistoryInvokedCount = 0
		var removeFromHistoryInvokedCount = 0

		init(watched: Bool, error: Error? = nil) {
			self.watched = watched
			self.error = error
		}

		func watched(movieId: Int) -> Single<WatchedMovieResult> {
			let result: WatchedMovieResult

			if let error = self.error {
				return Single.error(error)
			}

			if watched {
				let movies = try! JSONDecoder().decode([BaseMovie].self, from: Sync.history(params: nil).sampleData)
				let movie = movies[0]
				result = WatchedMovieResult.watched(movie: movie)
			} else {
				result = WatchedMovieResult.unwatched
			}

			return Single.just(result)
		}

		func fetchDetails(movieId: String) -> Observable<Movie> {
			return Observable.just(TraktEntitiesMock.createMovieDetailsMock())
		}

		func addToHistory(movieId: Int) -> Single<SyncMovieResult> {
			addToHistoryInvokedCount += 1

			guard let error = self.error else {
				return Single.just(SyncMovieResult.success)
			}

			return Single.error(error)
		}

		func removeFromHistory(movieId: Int) -> Single<SyncMovieResult> {
			removeFromHistoryInvokedCount += 1

			guard let error = self.error else {
				return Single.just(SyncMovieResult.success)
			}

			return Single.error(error)
		}
	}
}

final class ErrorMovieDetailsStoreMock: MovieDetailsRepository {
	private let error: Error

	init(error: Error) {
		self.error = error
	}

	func fetchDetails(movieId: String) -> Observable<Movie> {
		return Observable.error(error)
	}

	func watched(movieId: Int) -> PrimitiveSequence<SingleTrait, WatchedMovieResult> {
		return Single.error(error)
	}

	func addToHistory(movieId: Int) -> Single<SyncMovieResult> {
		return Single.error(error)
	}

	func removeFromHistory(movieId: Int) -> Single<SyncMovieResult> {
		return Single.error(error)
	}
}

final class MovieDetailsStoreMock: MovieDetailsRepository {
	private let movie: Movie

	init(movie: Movie) {
		self.movie = movie
	}

	func fetchDetails(movieId: String) -> Observable<Movie> {
		return Observable.just(movie).filter {
			$0.ids.slug == movieId
		}
	}

	func watched(movieId: Int) -> Single<WatchedMovieResult> {
		guard movie.ids.realId == "\(movieId)" else {
			return Single.just(WatchedMovieResult.unwatched)
		}

		let movies = try! JSONDecoder().decode([BaseMovie].self, from: Sync.history(params: nil).sampleData)

		let first = movies.first { $0.movie?.ids.realId == "\(movieId)" }

		guard let m = first else {
			return Single.just(WatchedMovieResult.unwatched)
		}

		return Single.just(WatchedMovieResult.watched(movie: m))
	}

	func addToHistory(movieId: Int) -> Single<SyncMovieResult> {
		return Single.just(SyncMovieResult.success)
	}

	func removeFromHistory(movieId: Int) -> Single<SyncMovieResult> {
		return Single.just(SyncMovieResult.success)
	}
}

final class MovieDetailsServiceMock: MovieDetailsInteractor {
	private let movieIds: MovieIds
	private let repository: MovieDetailsRepository
	private let genreRepository: GenreRepository
	private let imageRepository: ImageRepository

	init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
			imageRepository: ImageRepository, movieIds: MovieIds) {
		self.repository = repository
		self.genreRepository = genreRepository
		self.imageRepository = imageRepository
		self.movieIds = movieIds
	}

	func fetchDetails() -> Observable<MovieEntity> {
		let detailsObservable = repository.fetchDetails(movieId: movieIds.slug)
		let genresObservable = genreRepository.fetchMoviesGenres()
		let watchedObservable = repository.watched(movieId: movieIds.trakt).asObservable()

		return Observable.combineLatest(detailsObservable, genresObservable, watchedObservable) { (movie, genres, watched) in
			let movieGenres = genres.filter { genre -> Bool in
				return movie.genres?.contains(genre.slug) ?? false
			}

			let watchedAt: Date?

			if case .watched(let baseMovie) = watched {
				watchedAt = baseMovie.watchedAt
			} else {
				watchedAt = nil
			}

			return MovieEntityMapper.entity(for: movie, with: movieGenres, watchedAt: watchedAt)
		}
	}

	func fetchImages() -> Maybe<ImagesEntity> {
		guard let tmdbId = movieIds.tmdb else { return Maybe.empty() }
		return imageRepository.fetchMovieImages(for: tmdbId, posterSize: nil, backdropSize: nil)
	}

	func toggleWatched(movie: MovieEntity) -> Completable {
		return Completable.empty()
	}
}
