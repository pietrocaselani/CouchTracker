import RxSwift

final class ShowsManageriOSPresenter: ShowsManagerPresenter {
  private weak var view: ShowsManagerView?
  private let loginObservable: TraktLoginObservable
  private let disposeBag = DisposeBag()
  private let defaultIndex: Int
  private let modules: [ShowManagerModulePage]
  private let options: [ShowsManagerOption]

  init(view: ShowsManagerView, loginObservable: TraktLoginObservable, moduleSetup: ShowsManagerDataSource) {
    self.view = view
    self.loginObservable = loginObservable
    self.modules = moduleSetup.modulePages()
    self.defaultIndex = moduleSetup.defaultModuleIndex()
    self.options = moduleSetup.options
  }

  func viewDidLoad() {
    loginObservable.observe()
      .distinctUntilChanged()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] loginState in
        guard let view = self.view else { return }

        if loginState == .notLogged {
          view.showNeedsTraktLogin()
        } else {
          view.show(pages: self.modules, withDefault: self.defaultIndex)
        }
      }).disposed(by: disposeBag)
  }
}
