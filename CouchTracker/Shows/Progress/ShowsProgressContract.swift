import RxSwift
import TraktSwift

protocol ShowsProgressDataSource: class {
  func fetchWatchedShows() -> Observable<[WatchedShowEntity]>
  func addWatched(shows: [WatchedShowEntity]) throws
}

protocol ShowsProgressNetwork: class {
  func fetchWatchedShows(extended: Extended) -> Single<[BaseShow]>
}

protocol ShowsProgressRepository: class {
  func fetchWatchedShows(extended: Extended) -> Observable<[WatchedShowEntity]>
}

protocol ShowsProgressInteractor: class {
  init(repository: ShowsProgressRepository, schedulers: Schedulers)

  func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]>
}

protocol ShowsProgressRouter: class {
  func show(tvShow entity: WatchedShowEntity)
}

protocol ShowsProgressPresenter: class {
  var dataSource: ShowsProgressViewDataSource { get }
  init(view: ShowsProgressView, interactor: ShowsProgressInteractor,
       viewDataSource: ShowsProgressViewDataSource, router: ShowsProgressRouter)

  func viewDidLoad()
  func updateShows()
  func handleFilter()
  func handleDirection()
  func changeSort(to index: Int, filter: Int)
  func selectedShow(at index: Int)
}

protocol ShowsProgressView: class {
  var presenter: ShowsProgressPresenter! { get set }

  func show(viewModels: [WatchedShowViewModel])
  func showError(message: String)
  func showLoading()
  func showEmptyView()
  func reloadList()
  func showOptions(for sorting: [String], for filtering: [String], currentSort: Int, currentFilter: Int)
}

protocol ShowsProgressViewDataSource: class {
  var viewModels: [WatchedShowViewModel] { get set }

  func update()
}
