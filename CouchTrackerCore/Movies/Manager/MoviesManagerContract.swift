import RxSwift

public enum MoviesManagerOption: String {
  case trending
  case search
}

public protocol MoviesManagerPresenter: AnyObject {
  init(dataSource: MoviesManagerDataSource)

  func observeViewState() -> Observable<MoviesManagerViewState>
  func viewDidLoad()
  func selectTab(index: Int)
}

public protocol MoviesManagerModuleCreator: AnyObject {
  func createModule(for option: MoviesManagerOption) -> BaseView
}

public protocol MoviesManagerDataSource: AnyObject {
  var options: [MoviesManagerOption] { get }
  var modulePages: [ModulePage] { get }
  var defaultModuleIndex: Int { get set }

  init(creator: MoviesManagerModuleCreator)
}
