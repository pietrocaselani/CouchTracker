import RxSwift

public final class ShowProgressCellService: ShowProgressCellInteractor {
    private let imageRepository: ImageRepository

    public init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }

    public func fetchPosterImageURL(for tmdbId: Int, with size: PosterImageSize?) -> Maybe<URL> {
        let maybe = imageRepository.fetchShowImages(for: tmdbId, posterSize: size, backdropSize: nil)

        return maybe.flatMap { images -> Maybe<URL> in
            guard let imageLink = images.posterImage()?.link, let url = URL(string: imageLink) else {
                return Maybe.empty()
            }
            return Maybe.just(url)
        }
    }
}
