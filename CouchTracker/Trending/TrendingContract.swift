import RxSwift
import Trakt

enum TrendingType {
  case movies
  case shows
}

protocol TrendingPresenter: class {
  var currentTrendingType: Variable<TrendingType> { get }
  var dataSource: TrendingDataSource { get }

  init(view: TrendingView, interactor: TrendingInteractor, router: TrendingRouter, dataSource: TrendingDataSource)

  func viewDidLoad()
  func showDetailsOfTrending(at index: Int)
}

protocol TrendingView: BaseView {
  var presenter: TrendingPresenter! { get set }
  var appConfigurationsPresentable: AppConfigurationsPresentable! { get set }
  var searchView: SearchView! { get set }

  func showEmptyView()
  func showTrendingsView()
}

protocol TrendingRouter: class {
  func showDetails(of movie: MovieEntity)
  func showDetails(of show: ShowEntity)
  func showError(message: String)
}

protocol TrendingInteractor: class {
  init(repository: TrendingRepository, imageRepository: ImageRepository)

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovieEntity]>
  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShowEntity]>
}

protocol TrendingRepository: class {
  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]>
  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]>
}

protocol TrendingDataSource: class {
  var viewModels: [TrendingViewModel] { get set }
}
