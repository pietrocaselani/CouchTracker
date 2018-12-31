import RxSwift

public enum ShowManagerOption: String {
  case overview
  case episode
  case seasons
}

public protocol ShowManagerPresenter: class {
  init(dataSource: ShowManagerDataSource)

  func observeViewState() -> Observable<ShowManagerViewState>
  func viewDidLoad()
  func selectTab(index: Int)
}

public protocol ShowManagerModuleCreator: class {
  func createModule(for option: ShowManagerOption) -> BaseView
}

public protocol ShowManagerDataSource: class {
  init(show: WatchedShowEntity, creator: ShowManagerModuleCreator)

  var showTitle: String? { get }
  var options: [ShowManagerOption] { get }
  var modulePages: [ModulePage] { get }
  var defaultModuleIndex: Int { get set }
}
