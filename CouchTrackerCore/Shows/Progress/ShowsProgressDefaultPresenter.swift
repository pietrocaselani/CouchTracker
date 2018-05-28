import RxSwift

public final class ShowsProgressDefaultPresenter: ShowsProgressPresenter {
	private let loginObservable: TraktLoginObservable
	private weak var view: ShowsProgressView?
	private let interactor: ShowsProgressInteractor
	private let router: ShowsProgressRouter
	private let disposeBag = DisposeBag()
	private var entities = [WatchedShowEntity]()
	private var originalEntities = [WatchedShowEntity]()
	public var dataSource: ShowsProgressViewDataSource

	public init(view: ShowsProgressView, interactor: ShowsProgressInteractor, viewDataSource: ShowsProgressViewDataSource,
													router: ShowsProgressRouter, loginObservable: TraktLoginObservable) {
		self.view = view
		self.interactor = interactor
		self.dataSource = viewDataSource
		self.router = router
		self.loginObservable = loginObservable
	}

	public func viewDidLoad() {
		loginObservable.observe()
			.distinctUntilChanged()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [unowned self] loginState in
				guard let view = self.view else { return }

				if loginState == .notLogged {
					view.showError(message: "You need to login on Trakt to access this content".localized)
					self.dataSource.update()
				} else {
					self.fetchShows()
				}

			}).disposed(by: disposeBag)
	}

	public func updateShows() {
		dataSource.update()
		fetchShows()
	}

	public func handleFilter() {
		let sorting = ShowProgressSort.allValues().map { $0.rawValue.localized }
		let filtering = ShowProgressFilter.allValues().map { $0.rawValue.localized }

		let listState = interactor.listState

		let sortIndex = listState.sort.index()
		let filterIndex = listState.filter.index()
		view?.showOptions(for: sorting, for: filtering, currentSort: sortIndex, currentFilter: filterIndex)
	}

	public func handleDirection() {
		let newListState = interactor.listState.builder().toggleDirection().build()
		interactor.listState = newListState
		reloadViewModels()
	}

	public func changeSort(to index: Int, filter: Int) {
		let sort = ShowProgressSort.sort(for: index)
		let filter = ShowProgressFilter.filter(for: filter)

		let newListState = interactor.listState.builder().sort(sort).filter(filter).build()

		interactor.listState = newListState

		reloadViewModels()
	}

	public func selectedShow(at index: Int) {
		let entity = entities[index]
		router.show(tvShow: entity)
	}

	private func applyFilterAndSort() -> [WatchedShowViewModel] {
		let listState = interactor.listState
		let currentFilter = listState.filter
		let currentSort = listState.sort
		let currentDirection = listState.direction

		entities = originalEntities.filter(currentFilter.filter()).sorted(by: currentSort.comparator())

		if currentDirection == .desc {
			entities = entities.reversed()
		}

		return entities.map { WatchedShowEntityMapper.viewModel(for: $0) }
	}

	private func reloadViewModels() {
		let sortedViewModels = applyFilterAndSort()

		dataSource.viewModels = sortedViewModels
		view?.reloadList()
	}

	private func fetchShows() {
		view?.showLoading()

		interactor.fetchWatchedShowsProgress()
			.do(onNext: { [unowned self] in
				self.originalEntities = $0
				self.entities = $0
			})
			.map { return $0.map { WatchedShowEntityMapper.viewModel(for: $0) } }
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [unowned self] _ in
				guard let view = self.view else { return }

				let viewModels = self.applyFilterAndSort()

				self.dataSource.viewModels = viewModels

				if viewModels.count > 0 {
					view.show(viewModels: viewModels)
				} else {
					view.showEmptyView()
				}
				}, onError: { [unowned self] error in
					self.view?.showError(message: error.localizedDescription)
					self.dataSource.update()
				}, onCompleted: { [unowned self] in
					if self.dataSource.viewModels.isEmpty {
						self.view?.showEmptyView()
					}
			}).disposed(by: disposeBag)
	}
}
