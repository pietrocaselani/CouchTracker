import Foundation
import RxSwift
import TraktSwift
@testable import CouchTrackerCore

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
}
