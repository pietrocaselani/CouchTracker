import RxSwift

final class ShowsManageriOSPresenter: ShowsManagerPresenter {
  private weak var view: ShowsManagerView?
  private let router: ShowsManagerRouter
  private let loginObservable: TraktLoginObservable
  private let disposeBag = DisposeBag()
  private let options: [ShowsManagerOption]

  init(view: ShowsManagerView, router: ShowsManagerRouter,
       loginObservable: TraktLoginObservable, moduleSetup: ShowsManagerModulesSetup) {
    self.view = view
    self.router = router
    self.loginObservable = loginObservable
    self.options = moduleSetup.options
  }

  func viewDidLoad() {
    loginObservable.observe()
      .distinctUntilChanged()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] loginState in
        if loginState == .notLogged {
          self.router.showNeedsLogin()
        } else {
          guard let view = self.view else { return }

          let titles = self.options.map { $0.rawValue.localized }

          view.showOptionsSelection(with: titles)
        }
      }).disposed(by: disposeBag)
  }

  func showOption(at index: Int) {
    router.show(option: options[index])
  }
}
