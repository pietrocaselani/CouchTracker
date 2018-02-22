import RxSwift
import TraktSwift

public final class MovieDetailsService: MovieDetailsInteractor {
	private let repository: MovieDetailsRepository
	private let genreRepository: GenreRepository
	private let imageRepository: ImageRepository
	private let movieIds: MovieIds

	public init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
													imageRepository: ImageRepository, movieIds: MovieIds) {
		self.repository = repository
		self.genreRepository = genreRepository
		self.imageRepository = imageRepository
		self.movieIds = movieIds
	}

	public func fetchDetails() -> Observable<MovieEntity> {
		let detailsObservable = repository.fetchDetails(movieId: movieIds.slug)
		let genresObservable = genreRepository.fetchMoviesGenres()

		return Observable.combineLatest(detailsObservable, genresObservable) { (movie, genres) -> MovieEntity in
			let movieGenres = genres.filter { genre -> Bool in
				return movie.genres?.contains(genre.slug) ?? false
			}

			return MovieEntityMapper.entity(for: movie, with: movieGenres)
		}
	}

	public func fetchImages() -> Observable<ImagesEntity> {
		guard let tmdbId = movieIds.tmdb else { return Observable.empty() }
		return imageRepository.fetchMovieImages(for: tmdbId, posterSize: .w780, backdropSize: .w780).asObservable()
	}
}
