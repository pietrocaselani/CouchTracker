import RxSwift

public final class MoviesManagerDefaultPresenter: MoviesManagerPresenter {
  private let viewStateSubject = BehaviorSubject<MoviesManagerViewState>(value: .loading)
  private let dataSource: MoviesManagerDataSource

  public init(dataSource: MoviesManagerDataSource) {
    self.dataSource = dataSource
  }

  public func observeViewState() -> Observable<MoviesManagerViewState> {
    viewStateSubject.distinctUntilChanged()
  }

  public func viewDidLoad() {
    viewStateSubject.onNext(.showing(pages: dataSource.modulePages, selectedIndex: dataSource.defaultModuleIndex))
  }

  public func selectTab(index: Int) {
    dataSource.defaultModuleIndex = index
  }
}
