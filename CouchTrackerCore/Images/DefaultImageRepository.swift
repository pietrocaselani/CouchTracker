import RxSwift

public final class DefaultImageRepository: ImageRepository {
  private let movieImageRepository: MovieImageRepository
  private let showImageRepository: ShowImageRepository
  private let episodeImageRepository: EpisodeImageRepository

  public init(movieImageRepository: MovieImageRepository,
              showImageRepository: ShowImageRepository,
              episodeImageRepository: EpisodeImageRepository) {
    self.movieImageRepository = movieImageRepository
    self.showImageRepository = showImageRepository
    self.episodeImageRepository = episodeImageRepository
  }

  public func fetchMovieImages(for movieId: Int,
                               posterSize: PosterImageSize?,
                               backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
    return movieImageRepository.fetchMovieImages(for: movieId, posterSize: posterSize, backdropSize: backdropSize)
  }

  public func fetchShowImages(for showId: Int,
                              posterSize: PosterImageSize?,
                              backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
    return showImageRepository.fetchShowImages(for: showId, posterSize: posterSize, backdropSize: backdropSize)
  }

  public func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Maybe<URL> {
    return episodeImageRepository.fetchEpisodeImages(for: episode, size: size)
  }
}
