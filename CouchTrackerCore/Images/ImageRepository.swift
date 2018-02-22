import RxSwift

public protocol ImageRepository: class {
	func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?,
																							backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity>
	func fetchShowImages(for showId: Int, posterSize: PosterImageSize?,
																						backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity>
	func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Maybe<URL>
}
