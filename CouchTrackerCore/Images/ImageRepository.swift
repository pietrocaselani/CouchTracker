import RxSwift

public protocol MovieImageRepository: AnyObject {
  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?,
                        backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity>
}

public protocol ShowImageRepository: AnyObject {
  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?,
                       backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity>
}

public protocol EpisodeImageRepository: AnyObject {
  func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Maybe<URL>
}

public protocol ImageRepository: MovieImageRepository, ShowImageRepository, EpisodeImageRepository {}
