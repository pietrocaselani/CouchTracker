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
  // swiftlint:disable implicitly_unwrapped_optional
  var presenter: TraktLoginPresenter! { get set }
  // swiftlint:enable implicitly_unwrapped_optional

  func loadLogin(using url: URL)
  func showError(error: Error)
}

public protocol TraktLoginPolicyDecider: AnyObject {
  func allowedToProceed(with request: URLRequest) -> Single<AuthenticationResult>
}
