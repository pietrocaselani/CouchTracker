import CouchTrackerCore
import UIKit

enum ShowsManagerModule {
  static func setupModule() -> BaseView {
    guard let view = R.storyboard.showsManager().instantiateInitialViewController() as? UINavigationController else {
      fatalError("Initial view controller from ShowsManager storyboard should be an UINavigation")
    }

    guard let showsManagerView = view.topViewController as? ShowsManagerViewController else {
      fatalError("Can't instantiate ShowsManagerViewController from Storyboard")
    }

    let userDefaults = Environment.instance.userDefaults

    let moduleCreator = ShowsManageriOSCreator()
    let modulesSetup = ShowsManagerDefaultModuleSetup(creator: moduleCreator, userDefaults: userDefaults)
    let presenter = ShowsManagerDefaultPresenter(dataSource: modulesSetup)

    showsManagerView.presenter = presenter

    return view
  }
}
