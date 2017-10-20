final class ShowManageriOSPresenter: ShowManagerPresenter {
  private weak var view: ShowManagerView?
  private let router: ShowManagerRouter
  private let options: [ShowManagerOption]

  init(view: ShowManagerView, router: ShowManagerRouter, moduleSetup: ShowManagerModulesSetup) {
    self.view = view
    self.router = router
    self.options = moduleSetup.options
  }

  func viewDidLoad() {
    let titles = options.map { $0.rawValue.localized }

    view?.showOptionsSelection(with: titles)
  }

  func showOption(at index: Int) {
    router.show(option: options[index])
  }
}
