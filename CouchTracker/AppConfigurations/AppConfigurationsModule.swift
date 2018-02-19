import UIKit

final class AppConfigurationsModule {
  private init() {
    Swift.fatalError("No instances for you!")
  }

  static func setupModule() -> BaseView {
    guard let navigationController = R.storyboard.appConfigurations.instantiateInitialViewController() else {
      fatalError("Impossible to instantiate initial view controller from AppConfigurations storyboard")
    }

    guard let view = navigationController.topViewController as? AppConfigurationsViewController else {
      fatalError("topViewController should be an instance of AppConfigurationsViewController")
    }

    let appConfigurationsOutput = Environment.instance.appConfigurationsOutput
    let traktProvider = Environment.instance.trakt
    let schedulers = Environment.instance.schedulers
    let userDefaults = UserDefaults.standard

    let dataSource = AppConfigurationsUserDefaultsDataSource(userDefaults: userDefaults)
    let appConfigurationsNetwork = AppConfigurationsMoyaNetwork(trakt: traktProvider)
    let repository = AppConfigurationsDefaultRepository(dataSource: dataSource,
                                                        network: appConfigurationsNetwork,
                                                        schedulers: schedulers)
    let interactor = AppConfigurationsService(repository: repository, output: appConfigurationsOutput)
    let router = AppConfigurationsiOSRouter(viewController: view)
    let presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)

    view.presenter = presenter

    return navigationController
  }
}
