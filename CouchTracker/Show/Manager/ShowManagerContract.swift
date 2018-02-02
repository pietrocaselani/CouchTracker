enum ShowManagerOption: String {
  case overview
  case episode
  case seasons
}

protocol ShowManagerPresenter: class {
  init(view: ShowManagerView, dataSource: ShowManagerDataSource)

  func viewDidLoad()
}

protocol ShowManagerDataSource: class {
  init(show: WatchedShowEntity)

  var showTitle: String? { get }
  var options: [ShowManagerOption] { get }
  var modulePages: [ModulePage] { get }
  var defaultModuleIndex: Int { get }
}

protocol ShowManagerView: class {
  var presenter: ShowManagerPresenter! { get set }
  var title: String? { get set }

  func show(pages: [ModulePage], withDefault index: Int)
}
