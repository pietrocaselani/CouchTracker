import UIKit

final class AppConfigurationsModule {
  private init() {}

  static func setupModule() -> BaseView {
    guard let navigationController = R.storyboard.appConfigurations.instantiateInitialViewController() else {
      fatalError("Impossible to instantiate initial view controller from AppConfigurations storyboard")
    }

    guard let view = navigationController.topViewController as? AppConfigurationsViewController else {
      fatalError("topViewController should be an instance of AppConfigurationsViewController")
    }

    let traktProvider = Environment.instance.trakt
    let userDefaults = UserDefaults.standard

    let dataSource = AppConfigurationsUserDefaultsDataSource(userDefaults: userDefaults)
    let repository = AppConfigurationsDefaultRepository(dataSource: dataSource, traktProvider: traktProvider)
    let interactor = AppConfigurationsService(repository: repository)
    let router = AppConfigurationsiOSRouter(viewController: view)
    let presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)

    view.presenter = presenter

    return navigationController
  }
}
