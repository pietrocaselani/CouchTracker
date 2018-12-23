import Foundation
import RxSwift
import TraktSwift

public protocol AppConfigurationsRepository: class {
  func fetchLoginState() -> Observable<LoginState>
  func fetchHideSpecials() -> Observable<Bool>
  func toggleHideSpecials() -> Completable
}

public protocol AppConfigurationsNetwork: class {
  func fetchUserSettings() -> Single<Settings>
}

public protocol AppConfigurationsDataSource: class {
  func save(settings: Settings) throws
  func fetchLoginState() -> Observable<LoginState>
  func toggleHideSpecials() throws
  func fetchHideSpecials() -> Observable<Bool>
}

public protocol AppConfigurationsRouter: class {
  func showTraktLogin(output: TraktLoginOutput)
  func showSourceCode()
  func showError(message: String)
}

public protocol AppConfigurationsInteractor: class {
  init(repository: AppConfigurationsRepository, output: AppConfigurationsOutput)

  func fetchAppConfigurationsState() -> Observable<AppConfigurationsState>
  func toggleHideSpecials() -> Completable
}

public protocol AppConfigurationsPresenter: class {
  init(view: AppConfigurationsView, interactor: AppConfigurationsInteractor, router: AppConfigurationsRouter)

  func viewDidLoad()
  func optionSelectedAt(index: Int)
}

public protocol AppConfigurationsView: class {
  var presenter: AppConfigurationsPresenter! { get set }

  func showConfigurations(models: [AppConfigurationsViewModel])
}

public protocol AppConfigurationsPresentable: class {
  func showAppSettings()
}
