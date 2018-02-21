import RxSwift
import TraktSwift

public final class TrendingiOSPresenter: TrendingPresenter {
	private static let limitPerPage = 25

	public weak var view: TrendingView?
	public var dataSource: TrendingDataSource

	private let trendingType: TrendingType
	private let interactor: TrendingInteractor
	private let disposeBag = DisposeBag()
	private var movies = [TrendingMovieEntity]()
	private var shows = [TrendingShowEntity]()
	private var currentMoviesPage = 0
	private var currentShowsPage = 0
	fileprivate let router: TrendingRouter

	public init(view: TrendingView, interactor: TrendingInteractor,
			router: TrendingRouter, dataSource: TrendingDataSource, type: TrendingType) {
		self.view = view
		self.interactor = interactor
		self.router = router
		self.dataSource = dataSource
		self.trendingType = type
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
		let observable = interactor.fetchMovies(page: currentMoviesPage, limit: TrendingiOSPresenter.limitPerPage)
			.do(onNext: { [unowned self] in
				self.movies = $0
			}).map { [unowned self] in self.transformToViewModels(entities: $0) }

		subscribe(on: observable, for: .movies)
	}

	private func fetchShows() {
		let observable = interactor.fetchShows(page: currentShowsPage, limit: TrendingiOSPresenter.limitPerPage)
			.do(onNext: { [unowned self] in
				self.shows = $0
			}).map { [unowned self] in self.transformToViewModels(entities: $0) }

		subscribe(on: observable, for: .shows)
	}

	private func subscribe(on observable: Observable<[TrendingViewModel]>, for type: TrendingType) {
		observable.asSingle().observeOn(MainScheduler.instance).subscribe(onSuccess: { [unowned self] in
			self.present(viewModels: $0)
			}, onError: { error in
				guard let moviesListError = error as? TrendingError else {
					self.router.showError(message: error.localizedDescription)
					return
				}

				self.router.showError(message: moviesListError.message)
		}).disposed(by: disposeBag)
	}

	fileprivate func present(viewModels: [TrendingViewModel]) {
		guard let view = view else { return }

		guard viewModels.count > 0 else {
			view.showEmptyView()
			return
		}

		dataSource.viewModels = viewModels

		view.showTrendingsView()
	}

	private func transformToViewModels(entities: [TrendingMovieEntity]) -> [TrendingViewModel] {
		return entities.map { TrendingMovieViewModelMapper.viewModel(for: $0.movie) }
	}

	private func transformToViewModels(entities: [TrendingShowEntity]) -> [TrendingViewModel] {
		return entities.map { TrendingShowViewModelMapper.viewModel(for: $0.show) }
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
