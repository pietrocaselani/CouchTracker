import CouchTrackerCore

enum AppConfigurationsModule {
  static func setupModule() -> BaseView {
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
    let router = AppConfigurationsiOSRouter()
    let presenter = AppConfigurationsDefaultPresenter(interactor: interactor, router: router)

    let viewController = AppConfigurationsViewController(presenter: presenter)

    router.viewController = viewController

    return UINavigationController(rootViewController: viewController)
  }
}
