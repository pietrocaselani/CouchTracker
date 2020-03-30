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
    appStateManager.loginURL()
  }

  public func allowedToProcess(request: URLRequest) -> Completable {
    policyDecider.allowedToProceed(with: request)
      .flatMapCompletable { [appStateManager] result -> Completable in
        guard result == .authenticated else { return Completable.empty() }

        return appStateManager.login()
      }
  }
}
