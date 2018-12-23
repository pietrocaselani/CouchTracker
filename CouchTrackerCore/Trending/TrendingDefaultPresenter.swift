import RxSwift
import TraktSwift

public final class TrendingDefaultPresenter: TrendingPresenter {
  private static let limitPerPage = 25

  public weak var view: TrendingView?
  public var dataSource: TrendingDataSource

  private let trendingType: TrendingType
  private let interactor: TrendingInteractor
  private let router: TrendingRouter
  private let schedulers: Schedulers
  private let disposeBag = DisposeBag()
  private var movies = [TrendingMovieEntity]()
  private var shows = [TrendingShowEntity]()
  private var currentMoviesPage = 0
  private var currentShowsPage = 0

  public init(view: TrendingView, interactor: TrendingInteractor,
              router: TrendingRouter, dataSource: TrendingDataSource, type: TrendingType, schedulers: Schedulers) {
    self.view = view
    self.interactor = interactor
    self.router = router
    self.dataSource = dataSource
    trendingType = type
    self.schedulers = schedulers
  }

  public func viewDidLoad() {
    if trendingType == .movies {
      fetchMovies()
    } else {
      fetchShows()
    }
  }

  public func showDetailsOfTrending(at index: Int) {
    if trendingType == .movies {
      showDetailsOfMovie(at: index)
    } else {
      showDetailsOfShow(at: index)
    }
  }

  private func fetchMovies() {
    let observable = interactor.fetchMovies(page: currentMoviesPage, limit: TrendingDefaultPresenter.limitPerPage)
      .do(onSuccess: { [unowned self] in
        self.movies = $0
      }).map { [unowned self] in self.transformToViewModels(entities: $0) }

    subscribe(on: observable)
  }

  private func fetchShows() {
    let observable = interactor.fetchShows(page: currentShowsPage, limit: TrendingDefaultPresenter.limitPerPage)
      .do(onSuccess: { [unowned self] in
        self.shows = $0
      }).map { [unowned self] in self.transformToViewModels(entities: $0) }

    subscribe(on: observable)
  }

  private func subscribe(on single: Single<[PosterViewModel]>) {
    single.observeOn(schedulers.mainScheduler)
      .subscribe(onSuccess: { [unowned self] in
        self.present(viewModels: $0)
      }, onError: { error in
        guard let moviesListError = error as? TrendingError else {
          self.router.showError(message: error.localizedDescription)
          return
        }

        self.router.showError(message: moviesListError.message)
      }).disposed(by: disposeBag)
  }

  private func present(viewModels: [PosterViewModel]) {
    guard let view = view else { return }

    guard viewModels.count > 0 else {
      view.showEmptyView()
      return
    }

    dataSource.viewModels = viewModels

    view.showTrendingsView()
  }

  private func transformToViewModels(entities: [TrendingMovieEntity]) -> [PosterViewModel] {
    return entities.map { PosterMovieViewModelMapper.viewModel(for: $0.movie) }
  }

  private func transformToViewModels(entities: [TrendingShowEntity]) -> [PosterViewModel] {
    return entities.map { PosterShowViewModelMapper.viewModel(for: $0.show) }
  }

  private func showDetailsOfMovie(at index: Int) {
    let movieEntity = movies[index].movie

    router.showDetails(of: movieEntity)
  }

  private func showDetailsOfShow(at index: Int) {
    let showEntity = shows[index].show
    router.showDetails(of: showEntity)
  }
}
