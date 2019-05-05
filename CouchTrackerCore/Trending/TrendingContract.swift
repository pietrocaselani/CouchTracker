import RxSwift
import TraktSwift

public enum TrendingType {
  case movies
  case shows
}

public protocol TrendingPresenter: AnyObject {
  var dataSource: TrendingDataSource { get }

  init(view: TrendingViewProtocol, interactor: TrendingInteractor,
       router: TrendingRouter, dataSource: TrendingDataSource, type: TrendingType, schedulers: Schedulers)

  func viewDidLoad()
  func showDetailsOfTrending(at index: Int)
}

public protocol TrendingViewProtocol: BaseView {
  // swiftlint:disable implicitly_unwrapped_optional
  var presenter: TrendingPresenter! { get set }
  // swiftlint:enable implicitly_unwrapped_optional

  func showEmptyView()
  func showTrendingsView()
  func showLoadingView()
}

public protocol TrendingRouter: AnyObject {
  func showDetails(of movie: MovieEntity)
  func showDetails(of show: ShowEntity)
  func showError(message: String)
}

public protocol TrendingInteractor: AnyObject {
  func fetchMovies(page: Int, limit: Int) -> Single<[TrendingMovieEntity]>
  func fetchShows(page: Int, limit: Int) -> Single<[TrendingShowEntity]>
}

public protocol TrendingRepository: AnyObject {
  func fetchMovies(page: Int, limit: Int) -> Single<[TrendingMovie]>
  func fetchShows(page: Int, limit: Int) -> Single<[TrendingShow]>
}

public protocol TrendingDataSource: AnyObject {
  var viewModels: [PosterViewModel] { get set }
}
