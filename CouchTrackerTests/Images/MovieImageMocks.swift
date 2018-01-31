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
