import RxSwift

public protocol MovieImageRepository: class {
  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?,
                        backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity>
}

public protocol ShowImageRepository: class {
  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?,
                       backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity>
}

public protocol EpisodeImageRepository: class {
  func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Maybe<URL>
}

public protocol ImageRepository: MovieImageRepository, ShowImageRepository, EpisodeImageRepository {}
