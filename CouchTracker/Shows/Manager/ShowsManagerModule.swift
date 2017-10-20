import UIKit

final class ShowsManagerModule {
  private init() {}

  static func setupModule() -> BaseView {
    guard let view = R.storyboard.showsManager().instantiateInitialViewController() as? UINavigationController else {
      fatalError("Initial view controller from ShowsManager storyboard should be an UINavigation")
    }

    guard let showsManagerView = view.topViewController as? ShowsManagerViewController else {
      fatalError("Can't instantiate ShowsManagerViewController from Storyboard")
    }

    let loginObservable = Environment.instance.loginObservable
    let router = ShowsManageriOSRouter(viewController: showsManagerView)
    let modulesSetup = ShowsManageriOSModuleSetup()
    let presenter = ShowsManageriOSPresenter(view: showsManagerView, router: router,
                                             loginObservable: loginObservable, moduleSetup: modulesSetup)

    showsManagerView.presenter = presenter

    return view
  }
}
