import UIKit

final class AppFlowModule {
  private init() {}

  static func setupModule() -> BaseView {
    let trendingView = TrendingModule.setupModule()

    guard let trendingViewController = trendingView as? UIViewController else {
      fatalError("trendingView should be an instance of UIViewController")
    }

    let showsView = ShowsManagerModule.setupModule()
    guard let showsViewController = showsView as? UIViewController else {
      fatalError("showsView should be an instance of UIViewController")
    }

    let viewControllers = [trendingViewController, showsViewController]

    guard let appFlowViewController = R.storyboard.appFlow.appFlowViewController() else {
      fatalError("Can't instantiate AppFlowViewController from Storyboard")
    }

    appFlowViewController.viewControllers = viewControllers

    return appFlowViewController
  }
}
