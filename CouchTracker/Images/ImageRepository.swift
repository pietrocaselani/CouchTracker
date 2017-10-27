import RxSwift

protocol ImageRepository: class {
  init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository)

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?,
                        backdropSize: BackdropImageSize?) -> Observable<ImagesEntity>
  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?,
                       backdropSize: BackdropImageSize?) -> Single<ImagesEntity>
  func fetchEpisodeImages(for episode: EpisodeEntity, size: EpisodeImageSizes?) -> Observable<URL>
}
