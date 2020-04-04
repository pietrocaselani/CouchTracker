import RxSwift
import TraktSwift

public final class TraktTokenPolicyDecider: TraktLoginPolicyDecider {
  private let trakt: TraktProvider

  public init(traktProvider: TraktProvider) {
    trakt = traktProvider
  }

  public func allowedToProceed(with request: URLRequest) -> Single<AuthenticationResult> {
    trakt.finishesAuthentication(with: request)
  }
}
