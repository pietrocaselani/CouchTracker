import RxSwift

final class ShowsProgressiOSPresenter: ShowsProgressPresenter {
  private weak var view: ShowsProgressView?
  private let interactor: ShowsProgressInteractor
  private let router: ShowsProgressRouter
  private let disposeBag = DisposeBag()
  private var originalEntities = [WatchedShowEntity]()
  private var entities = [WatchedShowEntity]()
  private var currentFilter = ShowProgressFilter.none
  private var currentSort = ShowProgressSort.title
  var dataSource: ShowsProgressViewDataSource

  init(view: ShowsProgressView, interactor: ShowsProgressInteractor,
       viewDataSource: ShowsProgressViewDataSource, router: ShowsProgressRouter) {
    self.view = view
    self.interactor = interactor
    self.dataSource = viewDataSource
    self.router = router
  }

  func viewDidLoad() {
    fetchShows(update: false)
  }

  func updateShows() {
    entities.removeAll()
    originalEntities.removeAll()
    dataSource.update()
    fetchShows(update: true)
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

  private func reloadViewModels() {
    let sortedViewModels = entities.map { [unowned self] in self.mapToViewModel($0) }

    dataSource.set(viewModels: sortedViewModels)
    view?.reloadList()
  }

  private func fetchShows(update: Bool) {
    interactor.fetchWatchedShowsProgress(update: update)
      .do(onNext: { [unowned self] in
        self.originalEntities.append($0)
        self.entities.append($0)
      }).map { [unowned self] entity in
        return self.mapToViewModel(entity)
      }.observeOn(MainScheduler.instance)
      .do(onNext: { [unowned self] viewModel in
        self.dataSource.add(viewModel: viewModel)
      })
      .subscribe(onNext: { [unowned self] _ in
        self.view?.newViewModelAvailable(at: self.dataSource.viewModelCount() - 1 )
      }, onError: { error in
        print(error)
      }, onCompleted: { [unowned self] in
        guard let view = self.view else { return }

        view.updateFinished()

        if self.dataSource.viewModelCount() == 0 {
          view.showEmptyView()
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
