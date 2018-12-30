import RxSwift

public final class ShowsManagerDefaultPresenter: ShowsManagerPresenter {
  private let viewStateSubject = BehaviorSubject<ShowsManagerViewState>(value: .loading)
  private let dataSource: ShowsManagerDataSource

  public init(dataSource: ShowsManagerDataSource) {
    self.dataSource = dataSource
  }

  public func observeViewState() -> Observable<ShowsManagerViewState> {
    return viewStateSubject.distinctUntilChanged()
  }

  public func viewDidLoad() {
    let pages = dataSource.modulePages
    let defaultIndex = dataSource.defaultModuleIndex

    viewStateSubject.onNext(.showing(pages: pages, selectedIndex: defaultIndex))
  }

  public func selectTab(index: Int) {
    dataSource.defaultModuleIndex = index
  }
}
