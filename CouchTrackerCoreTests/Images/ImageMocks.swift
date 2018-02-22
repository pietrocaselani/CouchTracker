import TMDBSwift
import RxSwift
@testable import CouchTrackerCore

let imageRepositoryRealMock = ImageRepositoryMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)
let imageRepositoryMock = EmptyImageRepositoryMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)

final class ErrorImageRepositoryMock: ImageRepository {
	private var error: Error!

	convenience init(error: Error) {
		self.init(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)
		self.error = error
	}

	init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {}

	func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
		return Maybe.error(error)
	}

	func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
		return Maybe.error(error)
	}

	func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Maybe<URL> {
		return Maybe.error(error)
	}
}
