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
  func showExternal(url: URL)
  func showError(message: String)
}

public protocol AppConfigurationsInteractor: class {
  init(repository: AppConfigurationsRepository, output: AppConfigurationsOutput)

  func fetchAppConfigurationsState() -> Observable<AppConfigurationsState>
  func toggleHideSpecials() -> Completable
}

public protocol AppConfigurationsPresenter: class {
  init(interactor: AppConfigurationsInteractor, router: AppConfigurationsRouter, schedulers: Schedulers)

  func viewDidLoad()
  func observeViewState() -> Observable<AppConfigurationsViewState>
  func select(configuration: AppConfigurationViewModel)
}
