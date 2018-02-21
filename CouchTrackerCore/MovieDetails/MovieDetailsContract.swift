import RxSwift
import TraktSwift

public protocol MovieDetailsRouter: class {
	func showError(message: String)
}

public protocol MovieDetailsPresenter: class {
	init(view: MovieDetailsView, interactor: MovieDetailsInteractor, router: MovieDetailsRouter)

	func viewDidLoad()
}

public protocol MovieDetailsView: BaseView {
	var presenter: MovieDetailsPresenter! { get set }

	func show(details: MovieDetailsViewModel)
	func show(images: ImagesViewModel)
}

public protocol MovieDetailsInteractor: class {
	init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
			imageRepository: ImageRepository, movieIds: MovieIds)

	func fetchDetails() -> Observable<MovieEntity>
	func fetchImages() -> Observable<ImagesEntity>
}

public protocol MovieDetailsRepository: class {
	func fetchDetails(movieId: String) -> Observable<Movie>
}
