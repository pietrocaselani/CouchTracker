import RxSwift
import TraktSwift

protocol MovieDetailsRouter: class {
	func showError(message: String)
}

protocol MovieDetailsPresenter: class {
	init(view: MovieDetailsView, interactor: MovieDetailsInteractor, router: MovieDetailsRouter)

	func viewDidLoad()
}

protocol MovieDetailsView: BaseView {
	var presenter: MovieDetailsPresenter! { get set }

	func show(details: MovieDetailsViewModel)
	func show(images: ImagesViewModel)
}

protocol MovieDetailsInteractor: class {
	init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
			imageRepository: ImageRepository, movieIds: MovieIds)

	func fetchDetails() -> Observable<MovieEntity>
	func fetchImages() -> Observable<ImagesEntity>
}

protocol MovieDetailsRepository: class {
	func fetchDetails(movieId: String) -> Observable<Movie>
}
