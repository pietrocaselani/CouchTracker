import RxSwift

public final class PosterCellService: PosterCellInteractor {
	private let imageRepository: ImageRepository

	public init(imageRepository: ImageRepository) {
		self.imageRepository = imageRepository
	}

	public func fetchPosterImageURL(of type: PosterViewModelType, with size: PosterImageSize?) -> Maybe<URL> {
		let imagesObservable: Maybe<ImagesEntity>

		switch type {
		case .movie(let tmdbMovieId):
			imagesObservable = imageRepository.fetchMovieImages(for: tmdbMovieId, posterSize: size, backdropSize: nil)
		case .show(let tmdbShowId):
			let single = imageRepository.fetchShowImages(for: tmdbShowId, posterSize: size, backdropSize: nil)
			imagesObservable = single
		}

		return imagesObservable.flatMap { images -> Maybe<URL> in
			guard let imageLink = images.posterImage()?.link,
				let imageURL = URL(string: imageLink) else {
					return Maybe.empty()
			}

			return Maybe.just(imageURL)
		}
	}
}
