import RxSwift

final class ShowProgressCellService: ShowProgressCellInteractor {
	private let imageRepository: ImageRepository

	init(imageRepository: ImageRepository) {
		self.imageRepository = imageRepository
	}

	func fetchPosterImageURL(for tmdbId: Int, with size: PosterImageSize?) -> Observable<URL> {
		let observable = imageRepository.fetchShowImages(for: tmdbId, posterSize: size, backdropSize: nil).asObservable()

		return observable.flatMap { images -> Observable<URL> in
			guard let imageLink = images.posterImage()?.link, let url = URL(string: imageLink) else {
				return Observable.empty()
			}
			return Observable.just(url)
		}
	}
}
