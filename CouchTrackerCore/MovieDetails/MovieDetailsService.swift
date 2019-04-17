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
    let genresObservable = genreRepository.fetchMoviesGenres().asObservable()
    let watchedObservable = repository.watched(movieId: movieIds.trakt).asObservable()

    return Observable.combineLatest(detailsObservable,
                                    genresObservable,
                                    watchedObservable) { (movie, genres, watchedMovieResult) -> MovieEntity in
      let movieGenres = genres.filter { genre -> Bool in
        movie.genres?.contains(genre.slug) ?? false
      }

      let watchedAt: Date?

      if case let .watched(watchedMovie) = watchedMovieResult {
        watchedAt = watchedMovie.watchedAt
      } else {
        watchedAt = nil
      }

      return MovieEntityMapper.entity(for: movie, with: movieGenres, watchedAt: watchedAt)
    }
  }

  public func fetchImages() -> Maybe<ImagesEntity> {
    guard let tmdbId = movieIds.tmdb else { return Maybe.empty() }
    return imageRepository.fetchMovieImages(for: tmdbId, posterSize: .w780, backdropSize: .w780)
  }

  public func toggleWatched(movie: MovieEntity) -> Completable {
    let single = movie.watchedAt == nil ?
      repository.addToHistory(movie: movie) :
      repository.removeFromHistory(movie: movie)

    return single.flatMapCompletable {
      switch $0 {
      case let .fail(error):
        return Completable.error(error)
      case .success:
        return Completable.empty()
      }
    }
  }
}
