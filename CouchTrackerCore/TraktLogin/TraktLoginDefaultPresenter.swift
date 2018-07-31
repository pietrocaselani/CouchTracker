import RxSwift

public final class TraktLoginDefaultPresenter: TraktLoginPresenter {
  private weak var view: TraktLoginView?
  private let interactor: TraktLoginInteractor
  private let output: TraktLoginOutput
  private let schedulers: Schedulers
  private let disposeBag = DisposeBag()

  public init(view: TraktLoginView, interactor: TraktLoginInteractor, output: TraktLoginOutput, schedulers: Schedulers) {
    self.view = view
    self.interactor = interactor
    self.output = output
    self.schedulers = schedulers
  }

  public func viewDidLoad() {
    interactor.fetchLoginURL()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onSuccess: { [weak self] url in
        self?.view?.loadLogin(using: url)
      }, onError: { [weak self] error in
        self?.output.logInFail(message: error.localizedDescription)
      }).disposed(by: disposeBag)
  }
}
