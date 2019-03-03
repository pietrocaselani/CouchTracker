import RxSwift

public final class TraktLoginDefaultPresenter: TraktLoginPresenter {
  private weak var view: TraktLoginView?
  private let interactor: TraktLoginInteractor
  private let schedulers: Schedulers
  private let disposeBag = DisposeBag()

  public init(view: TraktLoginView,
              interactor: TraktLoginInteractor,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.view = view
    self.interactor = interactor
    self.schedulers = schedulers
  }

  public func viewDidLoad() {
    interactor.fetchLoginURL()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onSuccess: { [weak self] url in
        self?.view?.loadLogin(using: url)
      }, onError: { [weak self] error in
        self?.view?.showError(error: error)
      }).disposed(by: disposeBag)
  }

  public func allowedToProcess(request: URLRequest) -> Completable {
    return interactor.allowedToProcess(request: request)
  }
}
