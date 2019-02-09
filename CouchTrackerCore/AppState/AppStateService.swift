import RxSwift

public final class AppStateService: AppStateInteractor {
  private let appStateManager: AppStateManager

  public init(appStateManager: AppStateManager) {
    self.appStateManager = appStateManager
  }

  public func fetchAppState() -> Observable<AppState> {
    return appStateManager.observe()
  }

  public func toggleHideSpecials() -> Completable {
    return appStateManager.toggleHideSpecials()
  }
}
