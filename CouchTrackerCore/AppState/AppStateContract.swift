import Foundation
import RxSwift
import TraktSwift

public enum AppStateViewState: Hashable {
  case loading
  case showing(configs: [AppStateViewModel])
}

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

public protocol AppStatePresenter: class {
  func viewDidLoad()
  func observeViewState() -> Observable<AppStateViewState>
  func select(configuration: AppConfigurationViewModel)
}
