@testable import CouchTrackerCore
import RxSwift

final class TraktLoginErrorInteractorMock: TraktLoginInteractor {
  private let error: Error
  init(traktProvider _: TraktProvider = TraktProviderMock(), error: Error) {
    self.error = error
  }

  init(traktProvider _: TraktProvider) {
    fatalError("Please, use init(traktProvider: error:)")
  }

  func fetchLoginURL() -> Single<URL> {
    return Single.error(error)
  }

  func allowedToProcess(request _: URLRequest) -> Completable {
    return Completable.empty()
  }
}

final class TraktLoginInteractorMock: TraktLoginInteractor {
  private let url: URL

  init(traktProvider: TraktProvider) {
    guard let oauthURL = traktProvider.oauth else {
      fatalError("Impossible to create oauthURL without a redirect URL.")
    }

    url = oauthURL
  }

  func fetchLoginURL() -> Single<URL> {
    return Single.just(url)
  }

  func allowedToProcess(request _: URLRequest) -> Completable {
    return Completable.empty()
  }
}

final class TraktLoginViewMock: TraktLoginView {
  var policyDecider: TraktLoginPolicyDecider!
  var presenter: TraktLoginPresenter!

  var invokedLoadLogin = false
  var invokedLoadLoginParameters: (url: URL, Void)?
  var showErrorInvokedCount = 0
  var showErrorLastParemeter: Error?

  func loadLogin(using url: URL) {
    invokedLoadLogin = true
    invokedLoadLoginParameters = (url, ())
  }

  func showError(error: Error) {
    showErrorInvokedCount += 1
    showErrorLastParemeter = error
  }
}
