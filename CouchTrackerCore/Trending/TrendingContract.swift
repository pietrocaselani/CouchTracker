import RxSwift
import TraktSwift

public enum TrendingType {
	case movies
	case shows
}

public protocol TrendingPresenter: class {
	var dataSource: TrendingDataSource { get }

	init(view: TrendingView, interactor: TrendingInteractor,
						router: TrendingRouter, dataSource: TrendingDataSource, type: TrendingType)

	func viewDidLoad()
	func showDetailsOfTrending(at index: Int)
}

public protocol TrendingView: BaseView {
	var presenter: TrendingPresenter! { get set }

	func showEmptyView()
	func showTrendingsView()
}

public protocol TrendingRouter: class {
	func showDetails(of movie: MovieEntity)
	func showDetails(of show: ShowEntity)
	func showError(message: String)
}

public protocol TrendingInteractor: class {
	init(repository: TrendingRepository, imageRepository: ImageRepository)

	func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovieEntity]>
	func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShowEntity]>
}

public protocol TrendingRepository: class {
	func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]>
	func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]>
}

public protocol TrendingDataSource: class {
	var viewModels: [TrendingViewModel] { get set }
}
