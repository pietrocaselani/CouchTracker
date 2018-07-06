import RxSwift
import TraktSwift

public protocol ShowOverviewRepository: class {
	func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show>
}

public protocol ShowOverviewInteractor: class {
	init(showIds: ShowIds, repository: ShowOverviewRepository,
						genreRepository: GenreRepository, imageRepository: ImageRepository)

	func fetchDetailsOfShow() -> Single<ShowEntity>
	func fetchImages() -> Maybe<ImagesEntity>
}

public protocol ShowOverviewPresenter: class {
	init(view: ShowOverviewView, router: ShowOverviewRouter, interactor: ShowOverviewInteractor)

	func viewDidLoad()
}

public protocol ShowOverviewRouter: class {
	func showError(message: String)
}

public protocol ShowOverviewView: class {
	var presenter: ShowOverviewPresenter! { get set }

	func show(details: ShowOverviewViewModel)
	func show(images: ImagesViewModel)
}
