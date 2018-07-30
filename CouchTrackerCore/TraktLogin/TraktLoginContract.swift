import Foundation
import RxSwift
import TraktSwift

public protocol TraktLoginInteractor: class {
    init?(traktProvider: TraktProvider)

    func fetchLoginURL() -> Single<URL>
}

public protocol TraktLoginPresenter: class {
    init(view: TraktLoginView, interactor: TraktLoginInteractor, output: TraktLoginOutput, schedulers: Schedulers)

    func viewDidLoad()
}

public protocol TraktLoginView: class {
    var presenter: TraktLoginPresenter! { get set }
    var policyDecider: TraktLoginPolicyDecider! { get set }

    func loadLogin(using url: URL)
}

public protocol TraktLoginOutput: class {
    func loggedInSuccessfully()
    func logInFail(message: String)
}

public protocol TraktLoginPolicyDecider: class {
    init(loginOutput: TraktLoginOutput)

    func allowedToProceed(with request: URLRequest) -> Single<AuthenticationResult>
}
