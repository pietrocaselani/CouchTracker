import RxSwift
import TraktSwift
@testable import CouchTrackerCore

let showDetailsRepositoryMock = ShowOverviewRepositoryMock(traktProvider: createTraktProviderMock())

final class ShowOverviewRepositoryErrorMock: ShowOverviewRepository {
	private let error: Error

	init(traktProvider: TraktProvider = createTraktProviderMock()) {
		self.error = NSError(domain: "io.github.pietrocaselani", code: 120)
	}

	init(traktProvider: TraktProvider = createTraktProviderMock(), error: Error) {
		self.error = error
	}

	func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
		return Single.error(error)
	}
}

final class ShowOverviewRepositoryMock: ShowOverviewRepository {
	private let provider: TraktProvider
	init(traktProvider: TraktProvider) {
		self.provider = traktProvider
	}

	func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
		return provider.shows.rx.request(.summary(showId: identifier, extended: extended)).map(Show.self)
	}
}

final class ShowOverviewInteractorMock: ShowOverviewInteractor {
	private let genreRepository: GenreRepository
	private let imageRepository: ImageRepository
	private let repository: ShowOverviewRepository
	private let showIds: ShowIds

	init(showIds: ShowIds, repository: ShowOverviewRepository,
			genreRepository: GenreRepository, imageRepository: ImageRepository) {
		self.showIds = showIds
		self.repository = repository
		self.genreRepository = genreRepository
		self.imageRepository = imageRepository
	}

	func fetchDetailsOfShow() -> Single<ShowEntity> {
		let genresObservable = genreRepository.fetchShowsGenres()
		let showObservable = repository.fetchDetailsOfShow(with: showIds.slug, extended: .full).asObservable()

		return Observable.combineLatest(showObservable, genresObservable, resultSelector: { (show, genres) -> ShowEntity in
			let showGenres = genres.filter { genre -> Bool in
				show.genres?.contains(where: { $0 == genre.slug }) ?? false
			}
			return ShowEntityMapper.entity(for: show, with: showGenres)
		}).asSingle()
	}

	func fetchImages() -> Maybe<ImagesEntity> {
		guard let tmdbId = showIds.tmdb else { return Maybe.empty() }

		return imageRepository.fetchShowImages(for: tmdbId, posterSize: nil, backdropSize: nil)
	}
}

final class ShowOverviewRouterMock: ShowOverviewRouter {
	var invokedShowError = false
	var invokedShowErrorParameters: (message: String, Void)?

	func showError(message: String) {
		invokedShowError = true
		invokedShowErrorParameters = (message, ())
	}
}

final class ShowOverviewViewMock: ShowOverviewView {
	var presenter: ShowOverviewPresenter!
	var invokedShowDetails = false
	var invokedShowDetailsParameters: (details: ShowOverviewViewModel, Void)?
	var invokedShowImages = false
	var invokedShowImagesParameters: (images: ImagesViewModel, Void)?

	func show(details: ShowOverviewViewModel) {
		invokedShowDetails = true
		invokedShowDetailsParameters = (details, ())
	}

	func show(images: ImagesViewModel) {
		invokedShowImages = true
		invokedShowImagesParameters = (images, ())
	}
}
