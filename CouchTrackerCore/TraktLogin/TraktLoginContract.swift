import Foundation
import RxSwift
import TraktSwift

public protocol TraktLoginInteractor: AnyObject {
  func fetchLoginURL() -> Single<URL>
  func allowedToProcess(request: URLRequest) -> Completable
}

public protocol TraktLoginPresenter: AnyObject {
  init(view: TraktLoginView, interactor: TraktLoginInteractor, schedulers: Schedulers)

  func viewDidLoad()
  func allowedToProcess(request: URLRequest) -> Completable
}

public protocol TraktLoginView: AnyObject {
  var presenter: TraktLoginPresenter! { get set }

  func loadLogin(using url: URL)
  func showError(error: Error)
}

public protocol TraktLoginPolicyDecider: AnyObject {
  func allowedToProceed(with request: URLRequest) -> Single<AuthenticationResult>
}
