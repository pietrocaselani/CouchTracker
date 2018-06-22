import RxSwift
import TraktSwift

public protocol MovieDetailsPresenter: class {
	init(interactor: MovieDetailsInteractor)

	func viewDidLoad()

	func observeViewState() -> Observable<MovieDetailsViewState>
	func observeImagesState() -> Observable<MovieDetailsImagesState>
	func handleWatched() -> Completable
}

public protocol MovieDetailsView: BaseView {
	var presenter: MovieDetailsPresenter! { get set }

	func show(details: MovieDetailsViewModel)
	func show(images: ImagesViewModel)
}

public protocol MovieDetailsInteractor: class {
	func fetchDetails() -> Observable<MovieEntity>
	func fetchImages() -> Maybe<ImagesEntity>
	func toggleWatched(movie: MovieEntity) -> Completable
}

public protocol MovieDetailsRepository: class {
	func fetchDetails(movieId: String) -> Observable<Movie>
	func watched(movieId: Int) -> Single<WatchedMovieResult>
	func addToHistory(movieId: Int) -> Single<SyncMovieResult>
	func removeFromHistory(movieId: Int) -> Single<SyncMovieResult>
}
