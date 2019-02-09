import Foundation
import RxSwift
import TraktSwift

public protocol AppStateDataHolder: class {
  func currentAppState() throws -> AppState
  func save(appState: AppState) throws
}

public protocol AppStateRouter: class {
  func showTraktLogin()
  func finishLogin()
  func showExternal(url: URL)
  func showError(message: String)
}

public protocol AppStateInteractor: class {
  func fetchAppState() -> Observable<AppState>
  func toggleHideSpecials() -> Completable
}

public protocol AppStatePresenter: class {
  func viewDidLoad()
  func observeViewState() -> Observable<AppStateViewState>
  func select(configuration: AppConfigurationViewModel)
}
