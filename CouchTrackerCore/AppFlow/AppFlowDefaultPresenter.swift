import RxSwift

public final class AppFlowDefaultPresenter: AppFlowPresenter {
  private let viewStateSubject = BehaviorSubject<AppFlowViewState>(value: AppFlowViewState.loading)
  private let repository: AppFlowRepository
  private let dataSource: AppFlowModuleDataSource

  public init(repository: AppFlowRepository, moduleDataSource: AppFlowModuleDataSource) {
    self.repository = repository
    dataSource = moduleDataSource
  }

  public func observeViewState() -> Observable<AppFlowViewState> {
    return viewStateSubject.distinctUntilChanged()
  }

  public func viewDidLoad() {
    let selectedIndex = repository.lastSelectedTab
    let pages = dataSource.modulePages

    viewStateSubject.onNext(AppFlowViewState.showing(pages: pages, selectedIndex: selectedIndex))
  }

  public func selectTab(index: Int) {
    repository.lastSelectedTab = index
  }
}
