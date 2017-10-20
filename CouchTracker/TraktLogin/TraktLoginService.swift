import RxSwift

final class TraktLoginService: TraktLoginInteractor {
  private let oauthURL: URL

  init?(traktProvider: TraktProvider) {
    guard let url = traktProvider.oauth else {
      return nil
    }

    self.oauthURL = url
  }

  func fetchLoginURL() -> Single<URL> {
    return Single.just(oauthURL)
  }
}
