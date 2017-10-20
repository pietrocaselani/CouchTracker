enum ShowsManagerOption: String {
  case progress
  case now
}

protocol ShowsManagerRouter: class {
  func showNeedsLogin()
  func show(option: ShowsManagerOption)
}

protocol ShowsManagerPresenter: class {
  init(view: ShowsManagerView, router: ShowsManagerRouter,
       loginObservable: TraktLoginObservable, moduleSetup: ShowsManagerModulesSetup)

  func viewDidLoad()
  func showOption(at index: Int)
}

protocol ShowsManagerView: class {
  var presenter: ShowsManagerPresenter! { get set }

  func showOptionsSelection(with titles: [String])
}

protocol ShowsManagerModulesSetup: class {
  var options: [ShowsManagerOption] { get }
}
