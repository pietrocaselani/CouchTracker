@testable import CouchTrackerCore
import RxSwift
import TMDBSwift

let imageRepositoryRealMock = ImageRepositoryMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)
let imageRepositoryMock = EmptyImageRepositoryMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)

final class ErrorImageRepositoryMock: ImageRepository {
    private var error: Error!

    convenience init(error: Error) {
        self.init(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)
        self.error = error
    }

    init(tmdb _: TMDBProvider, tvdb _: TVDBProvider, cofigurationRepository _: ConfigurationRepository) {}

    func fetchMovieImages(for _: Int, posterSize _: PosterImageSize?, backdropSize _: BackdropImageSize?) -> Maybe<ImagesEntity> {
        return Maybe.error(error)
    }

    func fetchShowImages(for _: Int, posterSize _: PosterImageSize?, backdropSize _: BackdropImageSize?) -> Maybe<ImagesEntity> {
        return Maybe.error(error)
    }

    func fetchEpisodeImages(for _: EpisodeImageInput, size _: EpisodeImageSizes?) -> Maybe<URL> {
        return Maybe.error(error)
    }
}
