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
    let memoryCache = Environment.instance.memoryCache
    let diskCache = Environment.instance.diskCache

    let userDefaults = UserDefaults.standard
    let repository = AppConfigurationsUserDefaultsRepository(userDefaults: userDefaults, traktProvider: traktProvider)
    let interactor = AppConfigurationsService(repository: repository, memoryCache: memoryCache, diskCache: diskCache)
    let router = AppConfigurationsiOSRouter(viewController: view, traktProvider: traktProvider)
    let presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)

    view.presenter = presenter

    return navigationController
  }
}
