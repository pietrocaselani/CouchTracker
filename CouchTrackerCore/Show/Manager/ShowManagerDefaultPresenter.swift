import RxSwift

public final class ShowManagerDefaultPresenter: ShowManagerPresenter {
  private let viewStateSubject = BehaviorSubject<ShowManagerViewState>(value: .loading)
  private let dataSource: ShowManagerDataSource

  public init(dataSource: ShowManagerDataSource) {
    self.dataSource = dataSource
  }

  public func observeViewState() -> Observable<ShowManagerViewState> {
    return viewStateSubject.distinctUntilChanged()
  }

  public func viewDidLoad() {
    let title = dataSource.showTitle
    let pages = dataSource.modulePages
    let index = dataSource.defaultModuleIndex

    viewStateSubject.onNext(.showing(title: title, pages: pages, index: index))
  }

  public func selectTab(index: Int) {
    dataSource.defaultModuleIndex = index
  }
}
