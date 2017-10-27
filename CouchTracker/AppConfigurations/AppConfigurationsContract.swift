import Foundation
import Trakt
import RxSwift

protocol AppConfigurationsRepository: class {
  var preferredLocales: [Locale] { get }
  var preferredContentLocale: Locale { get set }
  func fetchLoggedUser(forced: Bool) -> Observable<User>
}

protocol AppConfigurationsRouter: class {
  func showTraktLogin(output: TraktLoginOutput)
  func showError(message: String)
}

protocol AppConfigurationsInteractor: class {
  init(repository: AppConfigurationsRepository, memoryCache: AnyCache<Int, NSData>, diskCache: AnyCache<Int, NSData>)

  func fetchLoginState(forced: Bool) -> Observable<LoginState>
  func deleteCache()
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
