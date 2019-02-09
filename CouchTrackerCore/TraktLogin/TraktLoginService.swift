import RxSwift
import TraktSwift

public final class TraktLoginService: TraktLoginInteractor {
  private let appStateManager: AppStateManager
  private let policyDecider: TraktLoginPolicyDecider

  public init(appStateManager: AppStateManager,
              policyDecider: TraktLoginPolicyDecider) {
    self.appStateManager = appStateManager
    self.policyDecider = policyDecider
  }

  public func fetchLoginURL() -> Single<URL> {
    return appStateManager.loginURL()
  }

  public func allowedToProcess(request: URLRequest) -> Completable {
    return policyDecider.allowedToProceed(with: request)
      .flatMapCompletable { [weak self] result -> Completable in
        guard let strongSelf = self else { return Completable.empty() }

        guard result == .authenticated else { return Completable.empty() }

        return strongSelf.appStateManager.login()
      }
  }
}
