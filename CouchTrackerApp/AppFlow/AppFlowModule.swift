import CouchTrackerCore
import UIKit

public final class AppFlowModule {
  private init() {
    Swift.fatalError("No instances for you!")
  }

  public static func setupModule() -> BaseView {
    guard let appFlowViewController = R.storyboard.appFlow.appFlowViewController() else {
      fatalError("Can't instantiate AppFlowViewController from Storyboard")
    }

    let userDefaults = Environment.instance.userDefaults

    let repository = AppFlowUserDefaultsRepository(userDefaults: userDefaults)
    let dataSource = AppFlowiOSModuleDataSource()
    let presenter = AppFlowDefaultPresenter(repository: repository,
                                            moduleDataSource: dataSource)

    appFlowViewController.presenter = presenter

    return appFlowViewController
  }
}
