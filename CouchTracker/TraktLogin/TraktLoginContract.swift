import RxSwift
import Foundation
import TraktSwift

protocol TraktLoginInteractor: class {
  init?(traktProvider: TraktProvider)

  func fetchLoginURL() -> Single<URL>
}

protocol TraktLoginPresenter: class {
  init(view: TraktLoginView, interactor: TraktLoginInteractor, output: TraktLoginOutput)

  func viewDidLoad()
}

protocol TraktLoginView: class {
  var presenter: TraktLoginPresenter! { get set }
  var policyDecider: TraktLoginPolicyDecider! { get set }

  func loadLogin(using url: URL)
}

protocol TraktLoginOutput: class {
  func loggedInSuccessfully()
  func logInFail(message: String)
}

protocol TraktLoginPolicyDecider: class {
  init(loginOutput: TraktLoginOutput)

  func allowedToProceed(with request: URLRequest) -> Observable<AuthenticationResult>
}
