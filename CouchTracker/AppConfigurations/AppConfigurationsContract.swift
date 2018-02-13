import Foundation
import TraktSwift
import RxSwift

protocol AppConfigurationsRepository: class {
  func fetchLoginState(forced: Bool) -> Observable<LoginState>
  func fetchHideSpecials() -> Observable<Bool>
  func toggleHideSpecials() -> Completable
}

protocol AppConfigurationsNetwork: class {
  func fetchUserSettings() -> Single<Settings>
}

protocol AppConfigurationsDataSource: class {
  func save(settings: Settings) throws
  func fetchLoginState() -> Observable<LoginState>
  func toggleHideSpecials() throws
  func fetchHideSpecials() -> Observable<Bool>
}

protocol AppConfigurationsRouter: class {
  func showTraktLogin(output: TraktLoginOutput)
  func showError(message: String)
}

protocol AppConfigurationsInteractor: class {
  init(repository: AppConfigurationsRepository, output: AppConfigurationsOutput)

  func fetchAppConfigurationsState(forced: Bool) -> Observable<AppConfigurationsState>
  func toggleHideSpecials() -> Completable
}

protocol AppConfigurationsPresenter: class {
  init(view: AppConfigurationsView, interactor: AppConfigurationsInteractor, router: AppConfigurationsRouter)

  func viewDidLoad()
  func optionSelectedAt(index: Int)
}

protocol AppConfigurationsView: class {
  var presenter: AppConfigurationsPresenter! { get set }

  func showConfigurations(models: [AppConfigurationsViewModel])
}

protocol AppConfigurationsPresentable: class {
  func showAppSettings()
}
