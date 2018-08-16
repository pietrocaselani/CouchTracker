import RxSwift
import TraktSwift

public protocol ShowsProgressDataSource: class {
  func fetchWatchedShows() -> Observable<[WatchedShowEntity]>
  func addWatched(shows: [WatchedShowEntity]) throws
}

public protocol ShowsProgressListStateDataSource: class {
  var currentState: ShowProgressListState { get set }
}

public protocol ShowsProgressInteractor: class {
  init(repository: ShowsProgressRepository,
       listStateDataSource: ShowsProgressListStateDataSource,
       schedulers: Schedulers)

  var listState: ShowProgressListState { get set }

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
