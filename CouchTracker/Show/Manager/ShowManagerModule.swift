import UIKit

final class ShowManagerModule {
  private init() {}

  static func setupModule(for show: WatchedShowEntity) -> BaseView {
    guard let view = R.storyboard.showManager.showManagerViewController() else {
      fatalError("Can't instantiate ShowManagerViewController from Storyboard")
    }

    let router = ShowManageriOSRouter(viewController: view, entity: show)
    let moduleSetup = ShowManageriOSModuleSetup()
    let presenter = ShowManageriOSPresenter(view: view, router: router, moduleSetup: moduleSetup)

    view.presenter = presenter

    return view
  }
}
