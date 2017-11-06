import TMDBSwift
import RxSwift

let imageRepositoryRealMock = ImageRepositoryMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)
let imageRepositoryMock = EmptyImageRepositoryMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)

final class ErrorImageRepositoryMock: ImageRepository {
  private var error: Error!

  convenience init(error: Error) {
    self.init(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)
    self.error = error
  }

  init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {}

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    return Observable.error(error)
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    return Single.error(error)
  }

  func fetchEpisodeImages(for episode: EpisodeEntity, size: EpisodeImageSizes?) -> Observable<URL> {
    return Observable.empty()
  }
}

func createMovieImagesRepositoryMock(_ images: ImagesEntity) -> ImageRepository {
  return ImagesRepositorySampleMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock, images: images)
}

func createTMDBConfigurationMock() -> Configuration {
  return try! JSONDecoder().decode(Configuration.self, from: ConfigurationService.configuration.sampleData)
}

func createImagesMock(movieId: Int) -> Images {
  return try! JSONDecoder().decode(Images.self, from: Movies.images(movieId: movieId).sampleData)
}
