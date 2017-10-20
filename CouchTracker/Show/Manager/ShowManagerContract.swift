enum ShowManagerOption: String {
  case overview
  case episode
  case seasons
}

protocol ShowManagerRouter: class {
  func show(option: ShowManagerOption)
}

protocol ShowManagerPresenter: class {
  init(view: ShowManagerView, router: ShowManagerRouter, moduleSetup: ShowManagerModulesSetup)

  func viewDidLoad()
  func showOption(at index: Int)
}

protocol ShowManagerView: class {
  var presenter: ShowManagerPresenter! { get set }

  func showOptionsSelection(with titles: [String])
}

protocol ShowManagerModulesSetup: class {
  var options: [ShowManagerOption] { get }
}
