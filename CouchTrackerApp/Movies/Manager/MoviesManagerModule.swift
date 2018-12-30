import CouchTrackerCore
import UIKit

enum MoviesManagerModule {
  static func setupModule() -> BaseView {
    let userDefaults = Environment.instance.userDefaults

    let creator = MoviesManageriOSModuleCreator()
    let dataSource = MoviesManagerDefaultDataSource(creator: creator, userDefaults: userDefaults)
    let presenter = MoviesManagerDefaultPresenter(dataSource: dataSource)

    let moviesManagerViewController = MoviesManagerViewController(presenter: presenter)

    return UINavigationController(rootViewController: moviesManagerViewController)
  }
}
