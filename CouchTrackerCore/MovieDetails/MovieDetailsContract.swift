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
}

public protocol MovieDetailsInteractor: class {
	func fetchDetails() -> Observable<MovieEntity>
	func fetchImages() -> Maybe<ImagesEntity>
	func toggleWatched(movie: MovieEntity) -> Completable
}

public protocol MovieDetailsRepository: class {
	func fetchDetails(movieId: String) -> Observable<Movie>
	func watched(movieId: Int) -> Single<WatchedMovieResult>
	func addToHistory(movie: MovieEntity) -> Single<SyncMovieResult>
	func removeFromHistory(movie: MovieEntity) -> Single<SyncMovieResult>
}
