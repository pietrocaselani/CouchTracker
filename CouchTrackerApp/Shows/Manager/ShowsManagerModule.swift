import CouchTrackerCore
import UIKit

enum ShowsManagerModule {
  static func setupModule() -> BaseView {
    let userDefaults = Environment.instance.userDefaults

    let moduleCreator = ShowsManageriOSCreator()
    let modulesSetup = ShowsManagerDefaultModuleSetup(creator: moduleCreator, userDefaults: userDefaults)
    let presenter = ShowsManagerDefaultPresenter(dataSource: modulesSetup)

    let showsManagerViewController = ShowsManagerViewController(presenter: presenter)
    return UINavigationController(rootViewController: showsManagerViewController)
  }
}
