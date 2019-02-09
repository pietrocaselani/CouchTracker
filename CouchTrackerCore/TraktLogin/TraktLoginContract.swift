import Foundation
import RxSwift
import TraktSwift

public protocol TraktLoginInteractor: class {
  func fetchLoginURL() -> Single<URL>
  func allowedToProcess(request: URLRequest) -> Completable
}

public protocol TraktLoginPresenter: class {
  init(view: TraktLoginView, interactor: TraktLoginInteractor, schedulers: Schedulers)

  func viewDidLoad()
  func allowedToProcess(request: URLRequest) -> Completable
}

public protocol TraktLoginView: class {
  var presenter: TraktLoginPresenter! { get set }

  func loadLogin(using url: URL)
  func showError(error: Error)
}

public protocol TraktLoginPolicyDecider: class {
  func allowedToProceed(with request: URLRequest) -> Single<AuthenticationResult>
}
