import RxSwift
import TraktSwift

public protocol ShowDetailsRepository: class {
	func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show>
}

public protocol ShowDetailsInteractor: class {
	init(showIds: ShowIds, repository: ShowDetailsRepository,
						genreRepository: GenreRepository, imageRepository: ImageRepository)

	func fetchDetailsOfShow() -> Single<ShowEntity>
	func fetchImages() -> Single<ImagesEntity>
}

public protocol ShowDetailsPresenter: class {
	init(view: ShowDetailsView, router: ShowDetailsRouter, interactor: ShowDetailsInteractor)

	func viewDidLoad()
}

public protocol ShowDetailsRouter: class {
	func showError(message: String)
}

public protocol ShowDetailsView: class {
	var presenter: ShowDetailsPresenter! { get set }

	func show(details: ShowDetailsViewModel)
	func show(images: ImagesViewModel)
}
