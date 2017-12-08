enum ShowsManagerOption: String {
  case progress
  case now
}

protocol ShowsManagerPresenter: class {
  init(view: ShowsManagerView, loginObservable: TraktLoginObservable, moduleSetup: ShowsManagerDataSource)

  func viewDidLoad()
}

protocol ShowsManagerView: class {
  var presenter: ShowsManagerPresenter! { get set }

  func show(pages: [ShowManagerModulePage], withDefault index: Int)

  func showNeedsTraktLogin()
}

protocol ShowsManagerDataSource: class {
  var options: [ShowsManagerOption] { get }

  func modulePages() -> [ShowManagerModulePage]

  func defaultModuleIndex() -> Int
}

struct ShowManagerModulePage {
  let page: BaseView
  let title: String
}
