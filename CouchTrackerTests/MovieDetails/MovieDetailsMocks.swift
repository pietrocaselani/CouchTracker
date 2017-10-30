import Foundation
import RxSwift
import TraktSwift

final class MovieDetailsViewMock: MovieDetailsView {
  var presenter: MovieDetailsPresenter!
  var invokedShow = false
  var invokedShowParameters: (details: MovieDetailsViewModel, Void)?
  var invokedShowImages = false
  var invokedShowImagesParameters: (images: ImagesViewModel, Void)?

  func show(details: MovieDetailsViewModel) {
    invokedShow = true
    invokedShowParameters = (details, ())
  }

  func show(images: ImagesViewModel) {
    invokedShowImages = true
    invokedShowImagesParameters = (images, ())
  }
}

final class MovieDetailsRouterMock: MovieDetailsRouter {
  var invokedShowError = false
  var invokedShowErrorParameters: (message: String, Void)?

  func showError(message: String) {
    invokedShowError = true
    invokedShowErrorParameters = (message, ())
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

    return Observable.combineLatest(detailsObservable, genresObservable) { (movie, genres) in
      let movieGenres = genres.filter { genre -> Bool in
        return movie.genres?.contains(genre.slug) ?? false
      }

      return MovieEntityMapper.entity(for: movie, with: movieGenres)
    }
  }

  func fetchImages() -> Observable<ImagesEntity> {
    guard let tmdbId = movieIds.tmdb else { return Observable.empty() }
    return imageRepository.fetchMovieImages(for: tmdbId, posterSize: nil, backdropSize: nil)
  }
}

func createMockMovies() -> [TrendingMovie] {
  let jsonArray = JSONParser.toArray(data: Movies.trending(page: 0, limit: 50, extended: .full).sampleData)
  return try! jsonArray.map { try TrendingMovie(JSON: $0) }
}

func createMovieMock(for movieId: String) -> Movie {
  let movies = createMockMovies()

  let trendingMovie = movies.first { $0.movie.ids.slug == movieId }

  return trendingMovie?.movie ?? createMovieDetailsMock(for: movieId)
}

func createMovieDetailsMock(for movieId: String) -> Movie {
  let jsonObject = JSONParser.toObject(data: Movies.summary(movieId: movieId, extended: .full).sampleData)
  return try! Movie(JSON: jsonObject)
}

func createMovieDetailsMock() -> Movie {
  return createMovieDetailsMock(for: "tron-legacy-2010")
}
