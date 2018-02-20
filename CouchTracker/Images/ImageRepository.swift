import RxSwift

protocol ImageRepository: class {
	func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?,
	backdropSize: BackdropImageSize?) -> Single<ImagesEntity>
	func fetchShowImages(for showId: Int, posterSize: PosterImageSize?,
	backdropSize: BackdropImageSize?) -> Single<ImagesEntity>
	func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Single<URL>
}
