import RxSwift

final class ShowsProgressiOSPresenter: ShowsProgressPresenter {
  private weak var view: ShowsProgressView?
  private let interactor: ShowsProgressInteractor
  private let router: ShowsProgressRouter
  private let disposeBag = DisposeBag()
  private var currentFilter = ShowProgressFilter.none
  private var currentSort = ShowProgressSort.title
  private var entities = [WatchedShowEntity]()
  private var originalEntities = [WatchedShowEntity]()
  var dataSource: ShowsProgressViewDataSource

  init(view: ShowsProgressView, interactor: ShowsProgressInteractor,
       viewDataSource: ShowsProgressViewDataSource, router: ShowsProgressRouter) {
    self.view = view
    self.interactor = interactor
    self.dataSource = viewDataSource
    self.router = router
  }

  func viewDidLoad() {
    fetchShows()
  }

  func updateShows() {
    dataSource.update()
    fetchShows()
  }

  func handleFilter() {
    let sorting = ShowProgressSort.allValues().map { $0.rawValue.localized }
    let filtering = ShowProgressFilter.allValues().map { $0.rawValue.localized }

    let sortIndex = currentSort.index()
    let filterIndex = currentFilter.index()
    view?.showOptions(for: sorting, for: filtering, currentSort: sortIndex, currentFilter: filterIndex)
  }

  func handleDirection() {
    entities.reverse()
    reloadViewModels()
  }

  func changeSort(to index: Int, filter: Int) {
    currentSort = ShowProgressSort.sort(for: index)
    currentFilter = ShowProgressFilter.filter(for: filter)

    entities = originalEntities.filter(currentFilter.filter())

    entities.sort(by: currentSort.comparator())

    reloadViewModels()
  }

  func selectedShow(at index: Int) {
    let entity = entities[index]
    router.show(tvShow: entity)
  }

  private func applyFilterAndSort() -> [WatchedShowViewModel] {
    entities = originalEntities.filter(currentFilter.filter()).sorted(by: currentSort.comparator())
    return entities.map { [unowned self] in self.mapToViewModel($0) }
  }

  private func reloadViewModels() {
    let sortedViewModels = entities.map { [unowned self] in self.mapToViewModel($0) }

    dataSource.viewModels = sortedViewModels
    view?.reloadList()
  }

  private func fetchShows() {
    view?.showLoading()

    interactor.fetchWatchedShowsProgress()
      .do(onNext: { [unowned self] in
        self.originalEntities = $0
        self.entities = $0
      }).map { [unowned self] in
        return $0.map { [unowned self] in self.mapToViewModel($0) }
      }.observeOn(MainScheduler.instance)
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
        }, onCompleted: { [unowned self] in
          if self.dataSource.viewModels.isEmpty {
            self.view?.showEmptyView()
          }
      }).disposed(by: disposeBag)
  }

  private func mapToViewModel(_ entity: WatchedShowEntity) -> WatchedShowViewModel {
    let nextEpisodeTitle = entity.nextEpisode.map { "\($0.season)x\($0.number) \($0.title)" }
    let nextEpisodeDateText = nextEpisodeDate(for: entity)
    let statusText = status(for: entity)

    return WatchedShowViewModel(title: entity.show.title ?? "TBA".localized,
                                nextEpisode: nextEpisodeTitle,
                                nextEpisodeDate: nextEpisodeDateText,
                                status: statusText,
                                tmdbId: entity.show.ids.tmdb)
  }

  private func status(for entity: WatchedShowEntity) -> String {
    let episodesRemaining = entity.aired - entity.completed
    var status = episodesRemaining == 0 ? "" : "episodes remaining".localized(String(episodesRemaining))

    if let nextwork = entity.show.network {
      status = episodesRemaining == 0 ? nextwork : "\(status) \(nextwork)"
    }

    return status
  }

  private func nextEpisodeDate(for entity: WatchedShowEntity) -> String {
    if let nextEpisodeDate = entity.nextEpisode?.firstAired?.shortString() {
      return nextEpisodeDate
    }

    if let showStatus = entity.show.status?.rawValue.localized {
      return showStatus
    }

    return "Unknown".localized
  }
}
