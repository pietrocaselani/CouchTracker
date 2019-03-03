import RxSwift
import TraktSwift

public protocol AppStateManager: AppStateObservable {
  func login() -> Completable
  func toggleHideSpecials() -> Completable
  func loginURL() -> Single<URL>
}

public final class DefaultAppStateManager: AppStateManager {
  private let trakt: TraktProvider
  private let dataHolder: AppStateDataHolder
  private let subject: BehaviorSubject<AppState>

  public init(appState: AppState, trakt: TraktProvider, dataHolder: AppStateDataHolder) {
    subject = BehaviorSubject<AppState>(value: appState)
    self.trakt = trakt
    self.dataHolder = dataHolder
  }

  public func observe() -> Observable<AppState> {
    return subject.distinctUntilChanged()
  }

  public func login() -> Completable {
    return fetchUserSettings()
      .asSingle()
      .flatMapCompletable { settings -> Completable in
        Completable.from { [weak self] in
          try self?.updateAppStateUserSettings(userSettings: settings)
        }
      }
  }

  public func toggleHideSpecials() -> Completable {
    return Completable.from { [weak self] in
      try self?.updateAppStateTogglingHideSpecials()
    }
  }

  public func loginURL() -> Single<URL> {
    guard let oauthURL = trakt.oauth else {
      return Single.error(CouchTrackerError.missingTraktOAuthURL)
    }

    return Single.just(oauthURL)
  }

  private func fetchUserSettings() -> Observable<Settings> {
    return trakt.users.rx.request(.settings)
      .filterSuccessfulStatusAndRedirectCodes()
      .map(Settings.self)
      .asObservable()
  }

  private func updateAppStateUserSettings(userSettings: Settings) throws {
    let newAppState = try dataHolder.currentAppState().buildUpon {
      $0.userSettings = userSettings
    }

    try saveAndNotifyNewState(appState: newAppState)
  }

  private func updateAppStateTogglingHideSpecials() throws {
    let newAppState = try dataHolder.currentAppState().buildUpon {
      $0.hideSpecials = !$0.hideSpecials
    }

    try saveAndNotifyNewState(appState: newAppState)
  }

  private func saveAndNotifyNewState(appState: AppState) throws {
    try dataHolder.save(appState: appState)
    subject.onNext(appState)
  }
}
