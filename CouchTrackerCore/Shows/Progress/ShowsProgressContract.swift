import RxSwift
import TraktSwift

public protocol ShowsProgressDataSource: class {
	func fetchWatchedShows() -> Observable<[WatchedShowEntity]>
	func addWatched(shows: [WatchedShowEntity]) throws
}

public protocol ShowsProgressNetwork: class {
	func fetchWatchedShows(extended: Extended) -> Single<[BaseShow]>
}

public protocol ShowsProgressRepository: class {
	func fetchWatchedShows(extended: Extended) -> Observable<[WatchedShowEntity]>
}

public protocol ShowsProgressInteractor: class {
	init(repository: ShowsProgressRepository, schedulers: Schedulers)

	func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]>
}

public protocol ShowsProgressRouter: class {
	func show(tvShow entity: WatchedShowEntity)
}

public protocol ShowsProgressPresenter: class {
	var dataSource: ShowsProgressViewDataSource { get }
	init(view: ShowsProgressView, interactor: ShowsProgressInteractor,
						viewDataSource: ShowsProgressViewDataSource, router: ShowsProgressRouter, loginObservable: TraktLoginObservable)

	func viewDidLoad()
	func updateShows()
	func handleFilter()
	func handleDirection()
	func changeSort(to index: Int, filter: Int)
	func selectedShow(at index: Int)
}

public protocol ShowsProgressView: class {
	var presenter: ShowsProgressPresenter! { get set }

	func show(viewModels: [WatchedShowViewModel])
	func showError(message: String)
	func showLoading()
	func showEmptyView()
	func reloadList()
	func showOptions(for sorting: [String], for filtering: [String], currentSort: Int, currentFilter: Int)
}

public protocol ShowsProgressViewDataSource: class {
	var viewModels: [WatchedShowViewModel] { get set }

	func update()
}
