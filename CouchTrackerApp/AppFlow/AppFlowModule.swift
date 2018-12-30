import CouchTrackerCore

public enum AppFlowModule {
  public static func setupModule() -> BaseView {
    let userDefaults = Environment.instance.userDefaults

    let dataSource = AppFlowiOSModuleDataSource()
    let repository = AppFlowUserDefaultsRepository(userDefaults: userDefaults)
    let presenter = AppFlowDefaultPresenter(repository: repository,
                                            moduleDataSource: dataSource)

    return AppFlowViewController(presenter: presenter)
  }
}
