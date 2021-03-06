import RxSwift

public enum ShowsManagerOption: String {
  case progress
  case now
  case trending
  case search
}

public protocol ShowsManagerPresenter: AnyObject {
  init(dataSource: ShowsManagerDataSource)

  func observeViewState() -> Observable<ShowsManagerViewState>
  func viewDidLoad()
  func selectTab(index: Int)
}

public protocol ShowsManagerDataSource: AnyObject {
  init(creator: ShowsManagerModuleCreator)

  var options: [ShowsManagerOption] { get }
  var modulePages: [ModulePage] { get }
  var defaultModuleIndex: Int { get set }
}

public protocol ShowsManagerModuleCreator: AnyObject {
  func createModule(for option: ShowsManagerOption) -> BaseView
}
