import Foundation
import TraktSwift
import RxSwift

protocol AppConfigurationsRepository: class {
  init(dataSource: AppConfigurationsDataSource)

  func fetchLoggedUser(forced: Bool) -> Observable<User>
}

protocol AppConfigurationsDataSource: class {
  func save(settings: Settings) throws
  func fetchSettings() -> Observable<Settings>
}

protocol AppConfigurationsRouter: class {
  func showTraktLogin(output: TraktLoginOutput)
  func showError(message: String)
}

protocol AppConfigurationsInteractor: class {
  init(repository: AppConfigurationsRepository)

  func fetchLoginState(forced: Bool) -> Observable<LoginState>
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
